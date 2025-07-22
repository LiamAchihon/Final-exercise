# AWS EKS Infrastructure with Terraform

קוד Terraform זה יוצר תשתית מלאה ב-AWS עבור EKS cluster כולל VPC, subnets, node groups ו-ECR repository.

## מבנה הקבצים

```
terraform/
├── versions.tf    # הגדרות Terraform ו-providers
├── variables.tf   # משתנים ו-locals
├── main.tf        # רכיבי התשתית הראשיים
├── outputs.tf     # פלטים
└── README.md      # המדריך הזה
```

## מה הקוד יוצר

### רכיבי התשתית:
- **S3 Bucket** - לשמירת Terraform state עם versioning ו-encryption
- **VPC** - רשת וירטואלית עם DNS support
- **Public Subnet** - עם Internet Gateway לגישה חיצונית
- **Private Subnet** - עם NAT Gateway לגישה יוצאת
- **EKS Cluster** - Kubernetes cluster מנוהל
- **2 Node Groups** - אחד ב-public subnet ואחד ב-private subnet
- **ECR Repository** - לשמירת Docker images
- **IAM Roles** - עם כל ההרשאות הנדרשות

### הגדרות ברירת מחדל:
- **Region**: us-west-2
- **Cluster Name**: my-eks-cluster
- **Kubernetes Version**: 1.28
- **Instance Type**: t3.medium
- **Node Groups**: 2 nodes בכל group (min: 1, max: 4)

## דרישות מוקדמות

1. **AWS CLI** מותקן ומוגדר עם credentials
2. **Terraform** גרסה 1.0 ומעלה
3. **הרשאות AWS** מתאימות ליצירת:
   - VPC, Subnets, Route Tables
   - EKS Clusters ו-Node Groups
   - IAM Roles ו-Policies
   - S3 Buckets
   - ECR Repositories

## איך להריץ

### שלב 1: הכנה
```bash
# ודא שיש לך AWS credentials
aws configure list

# בדוק שיש לך הרשאות מתאימות
aws sts get-caller-identity
```

### שלב 2: אתחול Terraform
```bash
cd terraform/
terraform init
```

### שלב 3: תכנון הפריסה
```bash
terraform plan
```

### שלב 4: יצירת התשתית
```bash
terraform apply
```
הקלד `yes` כשתתבקש לאשר.

**⏰ זמן יצירה צפוי: 15-20 דקות**

## Outputs

אחרי הרצה מוצלחת תקבל:

```
cluster_name = "my-eks-cluster"
cluster_endpoint = "https://xxxxx.gr7.us-west-2.eks.amazonaws.com"
ecr_url = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-app"
cluster_iam_role_arn = "arn:aws:iam::123456789012:role/my-eks-cluster-cluster-role"
node_group_iam_role_arn = "arn:aws:iam::123456789012:role/my-eks-cluster-node-group-role"
s3_bucket_name = "my-eks-cluster-terraform-state-abcd1234"
vpc_id = "vpc-xxxxx"
public_subnet_id = "subnet-xxxxx"
private_subnet_id = "subnet-xxxxx"
```

## התחברות ל-EKS Cluster

אחרי שהתשתית נוצרה, התחבר ל-cluster:

```bash
# עדכן kubeconfig
aws eks update-kubeconfig --region us-west-2 --name my-eks-cluster

# בדוק חיבור
kubectl get nodes
```

## התחברות ל-ECR

```bash
# התחבר ל-ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <ECR_URL>

# דוגמה:
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com
```

## התאמה אישית

אם אתה רוצה לשנות הגדרות, ערוך את החלק `locals` בקובץ variables.tf:

```hcl
locals {
  cluster_name = "השם-שלך"      # שנה כאן
  region       = "us-east-1"    # שנה region
  
  tags = {
    Environment = "production"  # שנה environment
    Project     = "הפרויקט-שלך"
  }
}
```

## עלויות צפויות

**⚠️ שים לב לעלויות:**
- EKS Cluster: ~$0.10/שעה
- EC2 Instances (4 x t3.medium): ~$0.17/שעה כל אחד
- NAT Gateway: ~$0.045/שעה + data transfer
- **סה"ל צפוי: ~$1.5-2/שעה**

## ניקוי התשתית

כדי למחוק את כל התשתית:

```bash
terraform destroy
```
הקלד `yes` כשתתבקש לאשר.

**⚠️ זה ימחק את כל הרכיבים ללא אפשרות שחזור!**

## פתרון בעיות נפוצות

### שגיאת הרשאות
```
Error: AccessDenied: User is not authorized to perform: eks:CreateCluster
```
**פתרון**: ודא שיש לך הרשאות EKS מלאות.

### שגיאת availability zones
```
Error: InvalidParameterException: Subnets specified must be in at least two different AZs
```
**פתרון**: הקוד אמור לטפל בזה אוטומטית, אבל אם יש בעיה נסה region אחר.

### שגיאת quota
```
Error: LimitExceeded: Cannot exceed quota for InstanceType
```
**פתרון**: בקש העלאת quota או שנה instance type.

## מה הלאה?

אחרי שהתשתית מוכנה, אתה יכול להמשיך לשלב 2:
- Dockerize את האפליקציה שלך
- דחוף את ה-image ל-ECR
- פרוס עם Helm על ה-EKS cluster
