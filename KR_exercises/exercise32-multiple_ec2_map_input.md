# 맵 변수를 기반으로 EC2 인스턴스 생성하기

## Introduction

이 실습에서는 Terraform의 맵 객체를 사용하여 고유한 구성으로 여러 EC2 인스턴스를 관리하는 방법을 배웁니다. 이는 복잡한 Terraform 프로젝트를 관리하고 인프라를 유연하고 쉽게 구성할 수 있도록 하는 데 중요한 기술입니다. 각 EC2 인스턴스에 대한 구성을 저장하는 맵 변수를 생성한 다음, `for_each` 루프를 사용하여 맵의 각 항목을 반복하고 제공된 구성으로 EC2 인스턴스를 생성하겠습니다. 시작해 보겠습니다!

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. EC2 인스턴스에 대한 구성을 저장하는 `ec2_instance_config_map`이라는 이름의 Terraform 변수를 생성합니다. 이 맵 객체에는 `instance_type`과 `ami`가 키로 포함되며, 둘 다 문자열입니다.
2. `terraform.tfvars` 파일의 `ec2_instance_config_map` 변수에 적절한 항목을 추가합니다. 예를 들어, `t2.micro`를 `instance_type`으로, `ubuntu`를 `ami`로 사용하는 `ubuntu_1` 인스턴스에 대한 항목이 하나 있을 수 있습니다.
3. `for_each` 루프를 사용하여 `ec2_instance_config_map` 변수를 기반으로 EC2 인스턴스를 생성합니다. 이 루프는 `ec2_instance_config_map`의 각 항목을 반복하여 제공된 구성으로 EC2 인스턴스를 생성합니다.

## Step-by-Step Guide

1. EC2 인스턴스에 대한 구성을 저장할 `ec2_instance_config_map`이라는 Terraform 변수를 정의합니다. 이것은 `instance_type`과 `ami`를 키로 하는 맵 객체이며, 둘 다 `string` 유형입니다.

    ```
    variable "ec2_instance_config_map" {
      type = map(object({
        instance_type = string
        ami           = string
      }))
    }
    ```

2. `terraform.tfvars` 파일에서 방금 생성한 `ec2_instance_config_map` 변수에 대한 새 항목을 추가합니다. 무료 티어를 염두에 두고 의미 있는 값을 추가합니다.

    ```
    ec2_instance_config_map = {
      ubuntu_1 = {
        instance_type = "t2.micro"
        ami           = "ubuntu"
      }

      nginx_1 = {
        instance_type = "t2.micro"
        ami           = "nginx"
      }
    }
    ```

3. 또한, 목록에서 추가 인스턴스를 생성하지 않도록 `ec2_instance_config_list` 변수를 빈 목록을 보유하도록 변경합니다.
4. 변수를 정의하고 `terraform.tfvars` 파일에 해당 값을 지정한 후 리소스 블록에서 이를 참조하여 EC2 인스턴스를 생성할 수 있습니다. `for_each` 루프를 사용하여 `ec2_instance_config_map`의 각 항목을 반복하고 제공된 구성으로 EC2 인스턴스를 생성합니다.

    ```
    resource "aws_instance" "from_map" {
      for_each      = var.ec2_instance_config_map
      ami           = local.ami_ids[each.value.ami]
      instance_type = each.value.instance_type
      subnet_id     = aws_subnet.main[0].id

      tags = {
        Name    = "${local.project}-${each.key}"
        Project = local.project
      }
    }
    ```

    이 블록에서 `for_each`는 `ec2_instance_config_map`을 반복하여 각 항목에 대한 EC2 인스턴스를 생성하는 데 사용됩니다. `ami` 및 `instance_type` 파라미터는 맵의 각 키를 사용하여 설정합니다. `subnet_id`는 `aws_subnet.main` 목록에서 0번째 서브넷의 ID로 하드코딩됩니다. `tags` 속성은 인스턴스 이름을 프로젝트 이름과 맵의 `키`의 조합으로 설정하는 데 사용되며, 프로젝트 태그는 프로젝트 이름으로 설정됩니다.

5. 모든 단계를 완료한 후에는 리소스를 반드시 파기하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! Terraform의 맵 객체를 사용하여 고유한 구성으로 여러 EC2 인스턴스를 관리하는 귀중한 기술을 습득하셨습니다. 배운 내용을 계속 연습하고 적용하여 Terraform 기술을 더욱 발전시켜 보세요. 수고하셨습니다!
