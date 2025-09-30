provider "aws" {
  region = "us-east-1"
  
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  // this region is only require for billing metrics

} 
