# Refactoring Configuration with the CLI and Moved Blocks

## Introduction

이 실습에서는 명령줄 인터페이스(CLI)와 이동된 블록을 사용하여 구성을 리팩토링하는 과정을 살펴보겠습니다. Terraform 상태와 EC2 인스턴스를 조작하는 작업을 할 것입니다. 이 연습의 주요 목표는 인스턴스 이름 바꾸기, 블록 마이그레이션, `moved` 블록 사용과 같은 작업에 익숙해지는 것입니다. 이 연습이 끝나면 불필요한 리소스 재생성 없이 인프라를 효율적으로 변경하는 방법을 잘 이해할 수 있을 것입니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 실행해보고 싶다면, 생성된 솔루션이 실행해야 하는 내용을 간략하게 살펴보세요:

1. 다음 연습을 위해 새 폴더를 생성하세요.
2. `default`로 레이블된 새 EC2 인스턴스를 생성하세요.
3. `terraform state mv` 명령을 사용하여 EC2 인스턴스의 레이블을 `new`로 변경하세요.
4. `count = 2` 메타-인자를 사용하여 `aws_instance` 블록을 이용해 두 개의 인스턴스를 배포하고, 기존 인스턴스를 새 인스턴스 리스트의 첫 번째 항목으로 이동하세요.
5. `count` 대신 `for_each`를 사용하고, 로컬 변수를 사용하여 인스턴스의 식별자로 사용할 두 개의 문자열을 정의하세요.
6. CLI 대신 `moved` 블록을 사용하여 목록에서 두 개의 리소스를 새로 정의된 EC2 리소스로 이동하세요.

## Step-by-Step Guide


1. 상태 조작 섹션과 관련된 파일을 정리하기 위해 새 폴더를 생성하세요.
2. 새로운 `provider.tf` 파일을 생성하고 Terraform을 이전 연습과 동일한 버전 제약 조건으로 구성하세요. 또한 원하는 지역으로 AWS 프로바이더를 구성하세요.
3. 구성 리팩토링 동기를 이해하기 위해 프로젝트에 새로운 EC2 인스턴스를 생성하세요. `terraform apply`를 실행하여 새 인스턴스를 생성하세요.


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

    resource "aws_instance" "default" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    ```


4. `aws_instance` 레이블을 `default`에서 `new`로 변경하세요. `terraform apply`를 실행하고 결과를 확인하세요. 리소스를 다시 생성해야 할 필요가 있을까요? 작업을 취소하고 다음 단계로 진행하세요.
5. `terraform state mv -dry-run [OLD-REFERENCE] [NEW-REFERENCE]`를 사용하여 Terraform 상태에서 리소스 이름을 변경하는 작업을 시각화하세요. `-dry-run` 옵션 없이 명령을 다시 실행한 다음 `terraform apply`를 실행하세요. 인프라에 변경 사항이 없어야 합니다.
6. 이제 두 개의 인스턴스를 배포해 봅시다. `aws_instance` 블록에 `count = 2` 메타-인자를 추가하세요. `terraform apply`를 실행하세요. Terraform은 이 작업을 어떻게 처리했나요?
7. Terraform은 count 메타-인자를 사용하여 단일 리소스에서 다중 리소스로 간단한 마이그레이션을 처리할 수 있지만, 리소스의 레이블을 변경하면 여전히 문제가 발생합니다. 레이블을 `new_list`로 변경한 다음 `terraform apply`를 실행하세요. Terraform은 필요 이상의 작업을 수행하려고 할 것입니다.
8. `terraform state mv aws_instance.new 'aws_instance.new_list[0]'` 명령을 사용하여 기존 인스턴스를 새 목록의 첫 번째 요소로 이동하세요. `terraform apply`를 실행하면 이제 하나의 인스턴스만 생성됩니다.
9. 이제 count 대신 `for_each`를 사용하도록 마이그레이션해 봅시다. `ec2_names`라는 로컬 변수에 두 개의 문자열을 저장하고, EC2 인스턴스 코드를 해당 이름을 기반으로 인스턴스를 생성하도록 마이그레이션하세요.


    ```
    locals {
      ec2_names = ["instance1", "instance2"]
    }

    resource "aws_instance" "new_final" {
      for_each      = toset(local.ec2_names)
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
    ```

10. 어떤 CLI 명령을 실행해야 할까요? CLI 대신 다른 방법을 채택하여 `moved` 블록을 사용해 봅시다. 목록에서 두 개의 리소스를 새로 정의된 리소스로 이동하세요.


    ```
    moved {
      from = aws_instance.new_list[0]
      to   = aws_instance.new_list["instance1"]
    }

    moved {
      from = aws_instance.new_list[1]
      to   = aws_instance.new_list["instance2"]
    }
    ```


11. `terraform plan`을 실행하고 Terraform이 출력하는 내용을 확인하세요. 작업을 확인하기 위해 `terraform apply`를 실행하고 "yes"를 입력하세요.
12. 연습을 마치기 전에 인프라를 삭제하세요!


## Congratulations on Completing the Exercise!

CLI와 moved block으로 Configuration을 리팩토링하는 이 연습을 완료한 것을 축하합니다! 훌륭하게 해냈으니 이제 테라폼 상태 조작에 대해 더 잘 이해하셨을 것입니다. 앞으로도 계속 열심히 하세요!
