# Working with the Terraform CLI

## Introduction

테라폼 명령줄 인터페이스(CLI)에 대한 이 실습에 오신 것을 환영합니다! 이 실습에서는 필수적인 Terraform 명령을 안내합니다. 파일의 유효성을 검사하고, 가독성을 높이기 위해 서식을 지정하고, 실행 계획을 만들고 적용하고, 상태를 관리하는 방법을 배우게 됩니다. 이 강력한 도구에 대해 자세히 알아보세요.

## Step-by-Step Guide

터미널에서 다음 명령을 실행하고 출력을 확인하세요. 각 명령에 대해 자세히 알아보려면 명령에 `-help` 플래그를 추가해 보세요!

-   `terraform validate`: Terraform 파일의 구문을 확인하고 내부적으로 일관성이 있는지 확인하지만 리소스가 존재하는지 또는 공급자가 올바르게 구성되었는지 확인하지는 않습니다.
-   `terraform fmt`: Terraform 구성 파일을 표준 형식과 스타일로 자동 업데이트하여 일관성과 가독성을 향상시킵니다. 이 명령은 현재 작업 디렉터리에 있는 파일에 대해서만 작동하지만 `-recursive` 플래그를 추가하여 중첩된 디렉터리에 있는 `.tf` 파일의 형식을 지정할 수도 있습니다.
-   `terraform plan`: 테라폼 파일에 정의된 원하는 상태를 달성하기 위해 테라폼이 어떤 작업을 수행할지 보여주는 실행 계획을 생성합니다. 이 명령은 실제 리소스나 상태를 수정하지 않습니다.
-   `terraform plan -out <filename>`: `terraform plan`과 유사하지만 `terraform apply`에서 사용할 수 있는 파일에 실행 계획을 기록하여 계획된 작업이 정확하게 수행되도록 합니다.
-   `terraform apply`: 실행 계획을 적용하여 원하는 리소스 상태에 도달하기 위해 필요한 변경을 수행합니다. `-out` 옵션과 함께 `terraform plan`을 실행하는 경우 `terraform apply <파일 이름>`을 실행하여 실행 계획을 제공할 수 있습니다.
-   `terraform show`: 상태 또는 계획 파일에서 사람이 읽을 수 있는 출력을 제공합니다. 현재 상태를 검사하거나 `terraform plan` 명령으로 계획된 작업을 확인하는 데 사용됩니다.
-   `terraform state list`: 상태 파일에 있는 모든 리소스를 나열하여 상태를 관리하고 조작하는 데 유용합니다.
-   `terraform destroy`: 상태 파일에서 추적된 모든 리소스를 삭제합니다. 이 명령은 `terraform apply` 명령에 `-destroy` 플래그를 전달하는 것과 동일합니다.
-   `terraform -help`: 테라폼 명령에 대한 도움말 정보를 제공합니다. 일반적인 개요를 위해 단독으로 사용하거나 특정 명령에 추가하여 해당 명령에 대한 자세한 도움말을 얻을 수 있습니다.

## Congratulations on Completing the Exercise!

Terraform CLI에서 이 연습을 완료해 주셔서 감사합니다! 테라폼을 마스터하는 데 중요한 단계를 밟으셨으며, 이 지식이 향후 프로젝트에 도움이 되기를 바랍니다. 계속 열심히 하세요!
