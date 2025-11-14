#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/13/25
#
# Iterates through a defined list of Docker named volumes,
# creates a compressed tarball for each, and uploads them to S3.
#
# REQUIREMENTS:
# - Docker must be installed and running.
# - AWS CLI must be installed and configured (aws configure).
# - Bash 4.0
# USAGE EXAMPLE: ./backup_all_volumes.sh s3://my-backup-bucket/path/to/project
#####################
#
# --- Configuration ---
#
# Array of all named volumes to be backed up from your docker-compose file.
# NOTE: For databases like PostgreSQL (postgres_data), a clean backup often requires 
# running 'pg_dump' inside the container first for true transactional consistency.
# This script performs a raw filesystem snapshot backup.
declare -a VOLUME_LIST=(
    "sonar_data_v"
    "sonar_data_v_logs"
    "sonar_data_ext"
    "sonar_data_plugins"
    "jenkins-docker-certs"
    "jenkins-data"
    "nexus_data_v"
    "postgres_data"
)

# Determine the Docker Compose Project Prefix.
# Based on user input, the Docker Compose project name is 'cicd'.
# This prefix is used to construct the full volume names (e.g., cicd_jenkins-data).
DOCKER_PROJECT_PREFIX="cicd"

# To use the short volume names (e.g., if using 'external: true'), uncomment the line below:
# DOCKER_PROJECT_PREFIX=""

# Temporary local directory to stage the compressed backup files
TEMP_BACKUP_DIR="/tmp/docker_volume_backups"

# Directory where the volume content will be mounted inside the temporary container
CONTAINER_VOLUME_PATH="/target_volume"

# --- Functions ---

# Check for required tools
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed or not in PATH." >&2
        exit 1
    fi
    if ! command -v aws &> /dev/null; then
        echo "Error: AWS CLI is not installed or not in PATH." >&2
        exit 1
    fi
    # Check if TEMP_BACKUP_DIR can be created
    mkdir -p "$TEMP_BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Could not create temporary directory $TEMP_BACKUP_DIR" >&2
        exit 1
    fi
}

# Displays usage information
show_usage() {
    echo "Usage: $0 <S3_BUCKET_PATH>"
    echo ""
    echo "Example:"
    echo "  $0 s3://devops-backups/ci-platform/data"
    exit 1
}

# Core logic to back up a single volume
backup_single_volume() {
    local SHORT_VOLUME_NAME="$1"
    local S3_TARGET_PATH="$2"

    # Construct the full volume name based on the prefix.
    local DOCKER_VOLUME_NAME
    if [ -n "$DOCKER_PROJECT_PREFIX" ]; then
        DOCKER_VOLUME_NAME="${DOCKER_PROJECT_PREFIX}_${SHORT_VOLUME_NAME}"
    else
        DOCKER_VOLUME_NAME="${SHORT_VOLUME_NAME}"
    fi
    
    echo "=================================================="
    echo "STARTING BACKUP for Volume: $DOCKER_VOLUME_NAME (Short name: $SHORT_VOLUME_NAME)"
    
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    local BACKUP_FILENAME="${SHORT_VOLUME_NAME}_${TIMESTAMP}.tar.gz"
    local LOCAL_BACKUP_FILE="${TEMP_BACKUP_DIR}/${BACKUP_FILENAME}"

    # 1. Create the compressed tarball using a temporary container
    echo "  -> Creating compressed tarball..."

    # Check if volume exists before attempting backup
    if ! docker volume inspect "$DOCKER_VOLUME_NAME" &> /dev/null; then
        echo "  !! WARNING: Docker volume '$DOCKER_VOLUME_NAME' not found. Skipping."
        echo "     (Verify the volume exists and DOCKER_PROJECT_PREFIX is correct, currently set to: '$DOCKER_PROJECT_PREFIX')"
        return 0 # Continue to next volume
    fi

    # Run tar inside a minimal container (alpine/busybox)
    docker run --rm \
        -v "$DOCKER_VOLUME_NAME":"$CONTAINER_VOLUME_PATH":ro \
        -v "$TEMP_BACKUP_DIR":/backup \
        busybox:latest \
        tar -czf "/backup/$BACKUP_FILENAME" -C "$CONTAINER_VOLUME_PATH" .
    
    if [ $? -ne 0 ]; then
        echo "  !! ERROR: Failed to create tarball for $DOCKER_VOLUME_NAME." >&2
        return 1 # Fail this volume
    fi

    # Check file size
    if [ ! -s "$LOCAL_BACKUP_FILE" ]; then
        echo "  !! ERROR: Backup file created but is empty ($LOCAL_BACKUP_FILE). Aborting upload." >&2
        rm -f "$LOCAL_BACKUP_FILE"
        return 1
    fi

    echo "  -> Tarball size: $(du -h "$LOCAL_BACKUP_FILE" | awk '{print $1}')"

    # 2. Upload to S3
    echo "  -> Uploading $BACKUP_FILENAME to S3 at $S3_TARGET_PATH/"
    echo "credential:"
    whoami
    pwd
    cat ~/.aws/credentials
    echo "credential: "
    aws s3 cp "$LOCAL_BACKUP_FILE" "$S3_TARGET_PATH/"
    
    if [ $? -ne 0 ]; then
        echo "  !! ERROR: AWS S3 upload failed for $DOCKER_VOLUME_NAME. Check credentials/path." >&2
        return 1
    fi

    # 3. Cleanup
    echo "  -> Upload successful! Cleaning up local file."
    rm -f "$LOCAL_BACKUP_FILE"
    
    return 0
}

# --- Main Execution ---

# Input validation
if [ "$#" -ne 1 ]; then
    show_usage
fi

S3_BUCKET_BASE_PATH="$1"

# Preliminary checks
check_dependencies

GLOBAL_SUCCESS=true

# Loop through all volumes and run the backup function
for volume in "${VOLUME_LIST[@]}"; do
    backup_single_volume "$volume" "$S3_BUCKET_BASE_PATH"
    if [ $? -ne 0 ]; then
        GLOBAL_SUCCESS=false
    fi
done

echo "=================================================="
if $GLOBAL_SUCCESS; then
    echo "ALL VOLUME BACKUPS COMPLETED SUCCESSFULLY."
    # Optionally remove the temporary directory if empty
    rmdir "$TEMP_BACKUP_DIR" 2>/dev/null
    exit 0
else
    echo "ONE OR MORE VOLUME BACKUPS FAILED. Check logs above." >&2
    exit 1
fi
