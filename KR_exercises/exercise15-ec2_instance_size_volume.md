# Customizing EC2 Instance Size and Volume Data

## Introduction

이 연습에서는 EC2 인스턴스의 크기와 볼륨 데이터를 사용자 정의하는 과정을 안내합니다. EC2 인스턴스 유형에 대한 변수를 정의하고, 이러한 변수에 유효성 검사를 추가하고, 볼륨 유형 및 크기에 대한 추가 변수를 생성하는 방법을 배우게 됩니다. 이러한 기술을 익히면 사양에 따라 리소스를 효율적으로 활용하는 EC2 인스턴스를 생성할 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. EC2 인스턴스의 유형을 지정하는 `ec2_instance_type`이라는 변수를 생성합니다. 이 변수는 문자열 유형이어야 하며 기본값은 `t2.micro`입니다.
2. 인스턴스 유형 변수에 유효성 검사를 추가하여 인스턴스 유형이 `t2.micro` 또는 `t3.micro`인지 확인합니다. 다른 값을 사용하면 Terraform은 "t2.micro 및 t3.micro 인스턴스만 지원됩니다"라는 오류 메시지를 반환해야 합니다.
3. EC2 볼륨 유형과 볼륨 크기를 모두 받기 위해 두 개의 변수를 추가로 생성합니다. 이 변수에는 올바른 유형, 합리적인 기본값 및 관련 설명이 있어야 합니다.
4. 생성한 변수를 활용하는 EC2 인스턴스를 생성합니다. 이 인스턴스는 데이터 소스를 통해 AMI ID를 검색하고 인스턴스 유형 및 루트 블록 장치 설정에 대해 이전에 정의한 변수를 사용해야 합니다.

## Step-by-Step Guide

1. EC2 인스턴스의 유형을 지정하는 `variable "ec2_instance_type"`을 정의합니다. 유형을 `string`으로 설정하고 기본값은 `"t2.micro"`로 설정합니다. 또한 유용한 설명을 추가합니다.

    ```
    variable "ec2_instance_type" {
      type        = string
      default = "t2.micro"
      description = "The type of the managed EC2 instances."
    }
    ```

2. 인스턴스 유형 변수에 유효성 검사를 추가합니다: 인스턴스 유형이 `t2.micro` 또는 `t3.micro`인지 확인하기 위해 변수 내에 `validation` 블록을 추가합니다. 다른 값을 사용하면 Terraform은 "t2.micro 및 t3.micro 인스턴스만 지원됩니다"라는 오류 메시지를 반환해야 합니다. 이는 인프라의 일관성과 무결성을 유지하는 데 도움이 됩니다.

    ```
    variable "ec2_instance_type" {
      type        = string
      default = "t2.micro"
      description = "The type of the managed EC2 instances."

      validation {
        condition     = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
        error_message = "“Only t2.micro and t3.micro instances are supported."
      }
    }
    ```

3. ec2 볼륨 유형과 볼륨 크기를 모두 받으려면 변수를 두 개 더 추가합니다. 올바른 유형을 사용하고, 합리적인 기본값을 설정하고, 관련 설명을 추가하세요.

    ```
    variable "ec2_volume_type" {
      type = string
      description = "The size and type of the root block volume for EC2 instances."
      default = "gp3"
    }

    variable "ec2_volume_size" {
      type = number
      description = "The size and type of the root block volume for EC2 instances."
      default = 10
    }
    ```

4. 생성한 변수를 활용하는 EC2 인스턴스를 생성합니다. 데이터 소스를 통해 AMI ID를 검색합니다. 인스턴스 유형과 루트 블록 디바이스 설정에 앞서 정의한 변수를 사용합니다. 즉, 변수를 조정하여 인스턴스의 유형과 루트 블록 장치를 쉽게 사용자 정의할 수 있습니다.

    ```
    resource "aws_instance" "compute" {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.ec2_instance_type

      root_block_device {
        delete_on_termination = true
        volume_size           = var.ec2_volume_size
        volume_type           = var.ec2_volume_type
      }
    }
    ```

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! 이러한 개념을 계속 연습하고 적용하여 이러한 기술에 대한 이해와 숙달을 심화하세요. 계속 노력하세요!
