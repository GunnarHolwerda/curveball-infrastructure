# Create key pair
aws ec2 create-key-pair --key-name CurveballKey --query 'KeyMaterial' --output text > CurveballKey.pem