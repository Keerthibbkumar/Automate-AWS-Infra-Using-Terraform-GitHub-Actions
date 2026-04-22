read -p "Enter the bucket name : " BKT
REGION="us-east-1"

aws s3 mb s3://$BKT --region $REGION 
 
if [ $? -ne 0 ]; then
    exit 1
fi

aws s3api put-bucket-versioning --bucket $BKT --versioning-configuration Status=Enabled

echo "Bucket $BKT is ready in $REGION with versioning enabled."