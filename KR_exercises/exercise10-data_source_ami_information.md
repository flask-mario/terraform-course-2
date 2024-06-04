# 데이터 소스를 사용하여 AMI 정보 가져오기

## Introduction

이 실습에서는 Terraform에서 AWS 데이터 소스를 사용하여 가장 최근의 Ubuntu AMI(Amazon Machine Image)를 검색하는 방법을 살펴보겠습니다. 검색된 AMI의 ID를 인쇄하는 출력 변수를 정의하고 이 ID를 사용하여 AWS 인스턴스 리소스를 구성합니다. 이 실습은 Terraform을 사용하여 AWS AMI를 처리하고 AWS 인스턴스를 구성하는 실질적인 경험을 제공하기 위해 고안되었습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 가장 최신 Ubuntu AMI를 검색할 AWS 데이터 소스를 정의합니다.
2. 검색된 AMI의 ID를 인쇄할 출력을 생성합니다.
3. 검색된 Ubuntu AMI ID를 사용하여 AWS EC2 인스턴스를 생성합니다. 무료 티어에 포함된 인스턴스 유형을 사용합니다. 대부분의 경우 `t2.micro` 인스턴스이지만, `t2.micro` 인스턴스를 사용할 수 없는 지역에서는 `t3.micro` 인스턴스일 수도 있습니다. 원치 않는 요금이 부과되지 않도록 미리 확인하시기 바랍니다!
4. 인스턴스의 루트 차단 장치를 볼륨 크기 10, 볼륨 유형 `gp3`로 구성하고 종료 시 삭제되도록 설정합니다.

### Useful Resources

-   AWS AMI Data Source - [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)

## Step-by-Step Guide

1. 먼저, AWS에서 가장 최신 Ubuntu AMI를 검색할 데이터 소스를 정의합니다. AMI의 소유자는 Ubuntu의 개발사인 Canonical입니다. 필터를 사용하여 조건에 일치하는 AMI만 검색합니다.

    ```
    data "aws_ami" "ubuntu" {
      most_recent = true
      owners      = ["099720109477"] # Owner is Canonical

      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
      }

      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    }
    ```

2. 그런 다음 검색한 AMI의 ID를 출력할 출력 변수를 정의합니다.

    ```
    output "ubuntu_ami_data" {
      value = data.aws_ami.ubuntu.id
    }
    ```

3. 마지막으로 AWS 인스턴스 리소스를 정의합니다. 검색한 Ubuntu AMI의 ID를 인스턴스의 AMI로 사용합니다. 인스턴스 유형을 `t2.micro`로 지정합니다. 또한 루트 블록 장치 구성을 볼륨 크기는 10, 볼륨 유형은 `gp3`로 지정하고 종료 시 삭제되도록 설정합니다.

    ```
    resource "aws_instance" "web" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3"
      }
    }
    ```

4. `terraform apply`를 실행하여 인프라를 생성합니다. 모든 것이 올바르게 구성되면 최신 Ubuntu AMI를 사용하여 AWS 계정에 새 `t2.micro` 인스턴스가 생성됩니다.
5. 모든 단계를 완료한 후에는 리소스를 반드시 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 성공적으로 완료했습니다! 이제 AWS AMI를 처리하고 Terraform을 사용하여 AWS 인스턴스를 구성하는 실무 경험을 쌓으셨습니다. 계속 열심히 연습하여 더 능숙해질 수 있도록 계속 연습하세요. 새로운 기술을 습득하는 데 있어 일관성이 핵심이라는 점을 기억하세요. 여러분의 성취를 다시 한 번 축하드립니다!