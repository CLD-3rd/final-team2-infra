# Cert-Manager Module

이 모듈은 Kubernetes 클러스터에 cert-manager를 설치하고 Let's Encrypt ClusterIssuer를 구성합니다.

## 기능

- ✅ Cert-manager Helm 차트 설치
- ✅ Let's Encrypt Staging ClusterIssuer
- ✅ Let's Encrypt Production ClusterIssuer
- ✅ Self-signed ClusterIssuer (테스트용)
- ✅ Prometheus 모니터링 지원 (선택사항)

## 사용법

```hcl
module "cert_manager" {
  source = "./modules/cert-manager"

  cert_manager_version = "1.13.0"
  letsencrypt_email    = "admin@goteego.store"
  ingress_class        = "nginx"
  enable_prometheus    = false
  common_tags          = var.common_tags
}
```

## 변수

| 변수명 | 설명 | 타입 | 기본값 |
|--------|------|------|--------|
| `cert_manager_version` | Cert-manager 버전 | string | `"1.13.0"` |
| `letsencrypt_email` | Let's Encrypt 이메일 | string | `"admin@goteego.store"` |
| `ingress_class` | Ingress 클래스 | string | `"nginx"` |
| `enable_prometheus` | Prometheus 모니터링 활성화 | bool | `false` |
| `common_tags` | 공통 태그 | map(string) | `{}` |

## 출력

| 출력명 | 설명 |
|--------|------|
| `cert_manager_namespace` | Cert-manager 네임스페이스 |
| `letsencrypt_staging_issuer` | Let's Encrypt Staging ClusterIssuer 이름 |
| `letsencrypt_prod_issuer` | Let's Encrypt Production ClusterIssuer 이름 |
| `selfsigned_issuer` | Self-signed ClusterIssuer 이름 |
| `cert_manager_status` | Cert-manager 설치 상태 |

## ClusterIssuer 사용법

### Let's Encrypt Staging (테스트용)
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-staging
spec:
  secretName: example-staging-tls
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
  dnsNames:
    - example.com
```

### Let's Encrypt Production (실제 사용)
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-prod
spec:
  secretName: example-prod-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
    - example.com
```

## 요구사항

- Kubernetes 클러스터
- Helm provider
- Kubernetes provider
- Ingress Controller (nginx 등) 