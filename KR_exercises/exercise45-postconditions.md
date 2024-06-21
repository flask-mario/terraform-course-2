# Postcondition Blocks

## Introduction

이 연습에서는 precondition(사전 조건) 블록을 EC2 인스턴스의 `self.instance_type` 속성을 참조하는 Postcondition(사후 조건) 블록으로 대체하는 방법을 배웁니다. 또한 실패하도록 의도된 두 번째 Postcondition(사후 조건) 블록을 생성하고, 기본 VPC 내에 새 서브넷을 생성하고, `aws_instance`에 `create_before_destroy = true` 수명 주기 속성을 추가합니다. 마지막으로 Postcondition을 업데이트하여 서브넷의 가용 영역이 유효한 가용 영역 이름 목록에 포함되어 있는지 확인합니다. 이 실습을 통해 Terraform에서 Postcondition 블록을 효과적으로 사용하는 방법을 이해하는 데 도움이 될 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. precondition(사전 조건) 블록을 제공된 변수 대신 EC2 인스턴스의 `self.instance_type` 속성을 참조하는 Postcondition(사후 조건) 블록으로 바꿉니다.
2. 기본 VPC 내에 새 서브넷을 생성하고 CIDR 블록을 `172.31.128.0/24`로 설정합니다.
3. `aws_instance`에 lifecycle 속성으로 `create_before_destroy = true`을 추가합니다.
4. Postcondition을 업데이트하여 서브넷의 가용 영역이 유효한 가용 영역 이름 목록에 포함되어 있는지 확인합니다.
5. `terraform apply`를 실행하고 작업이 성공적으로 완료되었는지 확인하여 모든 것이 작동하는지 확인합니다.

## Step-by-Step Guide

1. EC2 인스턴스가 생성되지 않았는지 확인합니다. 이전 연습에서 생성했다면 반드시 삭제하세요. 이전 강의에서 생성한 precondition 블록을 제거하고 EC2 인스턴스의 `self.instance_type` 속성을 참조하는 Postcondition 블록으로 대체합니다.

    ```
    resource "aws_instance" "this" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3"
      }

      lifecycle {
        postcondition {
          condition     = contains(local.allowed_instance_types, self.instance_type)
          error_message = "Self invalid instance type"
        }
      }
    }
    ```

2. 조건이 `self.availability_zone == "eu-central-1a"`로 설정된 두 번째 Postcondition 블록을 추가합니다. `eu-central-1` 지역을 사용하는 경우 가용성 영역에 다른 값을 사용하세요. 이 Postcondition 블록은 실패해야 하므로 의도적으로 설정한 것입니다. `terraform plan`을 실행하고 오류가 있는지 검사합니다. 오류가 없는 이유는 무엇인가요? 이제 `terraform apply` 명령을 실행하고 작동을 확인합니다. 무슨 일이 일어났나요?

    ```
    resource "aws_instance" "this" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = 10
        volume_type           = "gp3"
      }

      lifecycle {
        # create_before_destroy = true
        postcondition {
          condition     = contains(local.allowed_instance_types, self.instance_type)
          error_message = "Self invalid instance type"
        }
      }
    }
    ```

3. `aw_vpc` 데이터 소스를 사용하여 구성된 지역에 대한 기본 VPC를 가져옵니다.

    ```
    data "aws_vpc" "default" {
      default = true
    }
    ```

4. 가져온 VPC 데이터를 사용하여 새 서브넷을 생성합니다. CIDR 블록을 `172.31.128.0/24`로 설정합니다. 또한 가용성 영역 검사가 포함된 Postcondition 검사를 새로 생성된 이 서브넷으로 이동하고, 새로 생성된 이 서브넷을 참조하도록 `aws_instance` 리소스에서 `subnet_id`를 명시적으로 설정합니다.

    ```
    resource "aws_subnet" "this" {
      vpc_id     = data.aws_vpc.default.id
      cidr_block = "172.31.128.0/24"

      lifecycle {
        postcondition {
          condition     = self.availability_zone == "eu-central-1a"
          error_message = "Invalid AZ"
        }
      }
    }
    ```

5. 생성한 `aws_instance`에 lifecycle 속성으로 `create_before_destroy = true` 를 추가합니다. 이렇게 하면 이전 인스턴스가 삭제되기 전에 새 인스턴스가 생성됩니다. `terraform apply`를 실행하고 변경 사항을 승인한 다음 콘솔에서 어떤 일이 발생하는지 확인합니다. 어떤 리소스가 생성되었나요? 테라폼이 어디에서 멈췄나요?
6. 이제 postcondition 검사를 보다 현실적으로 업데이트하고 서브넷의 가용성 영역이 `aws_availability_zones` 데이터 소스를 통해 가져올 수 있는 유효한 가용성 영역 이름 목록에 포함되어 있는지 확인합니다.

    ```
    data "aws_availability_zones" "available" {
      state = "available"
    }

    resource "aws_subnet" "this" {
      vpc_id     = data.aws_vpc.default.id
      cidr_block = "172.31.128.0/24"

      lifecycle {
        postcondition {
          condition     = contains(data.aws_availability_zones.available.names, self.availability_zone)
          error_message = "Invalid AZ"
        }
      }
    }
    ```

7. `terraform apply`을 실행하고 명령이 오류 없이 실행되는지 확인합니다.
8. 이 연습이 끝나면 인프라를 파괴하세요.

## Congratulations on Completing the Exercise!

이 연습을 잘 마쳤습니다! 테라폼에서 postcondition 블록을 효과적으로 사용하는 방법을 이해하는 데 큰 진전을 이루었습니다. 앞으로도 계속 노력하세요!
