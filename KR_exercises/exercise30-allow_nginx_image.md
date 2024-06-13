# NGINX도 허용하도록 AMI 확장하기

## Introduction

이 실습에서는 인기 있는 오픈 소스 웹 서버인 NGINX를 포함하도록 Amazon 머신 이미지(AMI)를 확장해 보겠습니다. 여기에는 NGINX Bitnami AMI의 데이터 소스를 정의하고, `ami_ids` 로컬을 확장하여 NGINX 항목을 포함하고, `ec2_instance_config_list` 변수에 NGINX 인스턴스에 대한 객체를 추가하는 것이 포함됩니다. 인프라를 설정한 후에는 추가 비용을 피하기 위해 인프라를 적용하고 삭제합니다. 이 실습을 통해 Terraform에서 복잡한 구성을 관리하고 데이터 소스 및 리소스를 조작하는 데 유용한 연습을 할 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶은 경우, 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. NGINX Bitnami AMI의 AMI ID를 가져올 데이터 소스를 정의합니다.
2. NGINX에 대한 항목을 포함하도록 `ami_ids` 로컬을 확장합니다.
3. `ec2_instance_config_list`에 다른 오브젝트를 추가하여 NGINX 이미지가 포함된 인스턴스를 배포합니다.

## Step-by-Step Guide

1. 먼저 NGINX Bitnami AMI의 데이터 소스를 정의합니다. 구조는 우분투의 구조와 비슷하지만 이름을 변경해야 합니다. 이 정보는 어디에서 찾을 수 있을까요? (**힌트:** AWS 콘솔을 확인하면 과거와 동일한 방법으로 AMI ID를 찾을 수 있지만, 이제는 AMI 이름을 찾아야 합니다).

    ```
    data "aws_ami" "nginx" {
      most_recent = true

      filter {
        name   = "name"
        values = ["bitnami-nginx-1.25.4-*-linux-debian-12-x86_64-hvm-ebs-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }
    ```

2. nginx에 대한 항목을 포함하도록 `ami_ids` 로컬을 확장합니다.

    ```
    locals {
      ami_ids = {
        ubuntu = data.aws_ami.ubuntu.id
        nginx  = data.aws_ami.nginx.id
      }
    }
    ```

3. 이제 `ec2_instance_config_list` 변수를 확장하여 NGINX 인스턴스에 대한 다른 오브젝트를 포함시킵니다.

    ```
    ec2_instance_config_list = [
      {
        instance_type = "t2.micro",
        ami           = "ubuntu"
      },
      {
        instance_type = "t2.micro",
        ami           = "nginx"
      }
    ]
    ```

4. `terraform apply` 명령을 실행하고 변경 사항을 확인합니다. `aw_instance.from_list` 리소스를 건드리지 않고도 구성 확장을 쉽게 만들 수 있지 않았나요? 이것은 잘 설계된 코드를 가리킵니다!
5. 모든 단계를 완료한 후에는 반드시 리소스를 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료했습니다! 이제 Terraform에서 목록을 기반으로 여러 EC2 인스턴스를 생성하는 방법을 성공적으로 배웠습니다. 이는 Terraform에서 복잡한 구성을 관리하고 데이터 소스 및 리소스를 조작하는 데 있어 중요한 진전입니다. 계속 열심히 하세요!
