#!/bin/bash

read -p "Enter DynamoDB Table Name (e.g., terraform-lock): " TABLE_NAME
REGION="us-east-1"

echo "------------------------------------------"
echo "Checking if table '$TABLE_NAME' exists..."

aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Table '$TABLE_NAME' already exists. Skipping creation."
else
    echo "Creating DynamoDB table..."
    
    aws dynamodb create-table \
        --table-name "$TABLE_NAME" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --region "$REGION"

    if [ $? -eq 0 ]; then
        echo "Successfully created table '$TABLE_NAME'."
    else
        echo "Error: Failed to create table."
        exit 1
    fi
fi

echo "------------------------------------------"