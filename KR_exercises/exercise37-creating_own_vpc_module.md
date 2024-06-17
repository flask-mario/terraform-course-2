# 첫 번째 VPC 모듈 만들기

## Introduction

이 연습에서는 Terraform을 사용하여 첫 번째 가상 프라이빗 클라우드(VPC) 모듈을 만들어 보겠습니다. 다음 몇 번의 연습을 통해 계속 구현해 보겠습니다. 이 모듈은 네트워크 인프라를 관리하기 위한 유연하고 재사용 가능하며 표준화된 접근 방식을 제공합니다. 유효성 검사를 통한 CIDR 블록 변수 생성, 루트 구성에서의 모듈 사용 등 모듈을 구축하는 데 필요한 모든 요소를 다룰 것입니다. 이 연습이 끝나면 일관되게 VPC를 배포하는 데 사용할 수 있는 재현 가능한 코드를 만들 수 있습니다.

## Desired Outcome

자세한 단계별 내용과 솔루션 동영상을 살펴보기 전에 한 번 사용해 보고 싶다면 생성된 솔루션이 배포해야 하는 내용을 간략하게 살펴보세요:

1. 이 프로젝트의 `13-local-modules` 폴더를 새로 만듭니다.
2. 표준 모듈 구조인 `variables.tf`, `outputs.tf`, `provider.tf`, `main.tf`(또는 `vpc.tf`), `LICENSE` 및 `README.md`에 따라 `13-local-modules/modules/networking` 폴더에 새 모듈을 생성합니다.
3. 문자열 타입의 `vpc_cidr` 변수를 생성하고 유효성 검사를 추가하여 수신된 CIDR 블록이 유효한지 확인합니다.
4. 루트 구성 폴더 `13-local-modules`에 방금 생성한 모듈을 사용하는 `networking.tf` 파일을 새로 생성합니다.

## Step-by-Step Guide

1. 모듈 코드를 저장할 `13-local-modules`라는 새 폴더를 만듭니다.
2. `modules`라는 새 폴더를 만들고 이 폴더 아래에 `networking`이라는 다른 폴더를 만듭니다. 이는 모듈을 `modules` 폴더 아래에 배치한 다음 모듈당 하나의 폴더를 사용하는 규칙을 따릅니다.
3. 표준 모듈 구조를 위한 파일을 만듭니다:
    1. 모듈이 수신해야 하는 변수를 정의하는 `variables.tf` 파일.
    2. 모듈에서 제공하는 출력을 정의하는 `outputs.tf` 파일.
    3. 모듈의 종속성을 지정하는 `provider.tf` 파일.
    4. 생성할 리소스를 호스팅할 `main.tf` 파일(또는 원하는 경우 `vpc.tf` 파일).
    5. 모듈의 라이선스를 나중에 추가하게 될 `LICENSE` 파일.
    6. 모듈의 문서를 나중에 추가하게 될 `README.md` 파일.
4. 모듈 내부에 문자열 타입의 `vpc_cidr` 변수를 생성하고 유효성 검사를 통해 수신된 CIDR 블록이 유효한지 확인합니다.

    ```
    variable "vpc_cidr" {
      type = string

      validation {
        condition     = can(cidrnetmask(var.vpc_cidr))
        error_message = "The vpc_cidr must contain a valid CIDR block."
      }
    }
    ```

5. 루트 모듈 `13-local-modules` 아래에 `networking.tf` 파일을 새로 생성하고 방금 생성한 모듈을 사용합니다.

    ```
    module "vpc" {
      source   = "./modules/networking"
      vpc_cidr = "10.0.0.0/16"
    }
    ```

6. 모듈을 추가한 후 `terraform init`을 실행하여 모듈이 설치되도록 합니다.
7. `terraform plan`을 실행하여 오류가 있는지 확인합니다. 아직 인프라가 생성되지는 않지만 오류가 없다면 루트 구성에 모듈을 성공적으로 추가한 것입니다!
8. 모든 단계를 완료한 후에는 반드시 리소스를 삭제하세요!

## Congratulations on Completing the Exercise!

이 연습을 완료해 주셔서 감사합니다! Terraform을 사용하여 첫 번째 모듈을 성공적으로 만들었습니다. 이는 네트워크 인프라를 보다 효율적으로 관리하기 위한 중요한 단계입니다. 아직 끝나지 않았다는 것을 기억하세요! 다음 몇 번의 연습에서는 이 모듈을 계속 구현해 보겠습니다. 계속 열심히 해보세요!
