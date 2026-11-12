# Azure Storage Security

## Objective

Create a small Azure Storage resource and assess its access controls, network exposure, and encryption settings. Use synthetic test data only.

## Planned configuration

- Create one Storage Account in the existing resource group and Central US region.
- Use a globally unique, neutral name that does not reveal personal information.
- Keep anonymous blob access disabled.
- Prefer Microsoft Entra ID-based authorization for the test rather than distributing account keys.
- Review networking settings and restrict access to the minimum practical level for the exercise.
- Confirm the platform encryption setting and document the observed configuration.
- Avoid unnecessary redundancy or premium performance tiers.

Do not assume a setting is enabled simply because it is the default. Record the actual portal value.

## Validation workflow

1. Review the Storage Account's configuration and networking pages.
2. Confirm anonymous/public blob access is disabled at the account level.
3. Review whether individual containers permit anonymous access.
4. Review the assigned data-plane role and scope for the test identity.
5. Attempt an authorized test operation.
6. Where practical, verify that an identity without the required data role cannot perform the same operation.
7. Review the storage firewall/network access configuration.
8. Confirm encryption at rest is enabled.
9. Remove test data and unnecessary role assignments when finished.

## Evidence checklist

- [ ] Storage Account overview with sensitive identifiers redacted.
- [ ] Anonymous/public access configuration.
- [ ] Container access level.
- [ ] Network access configuration.
- [ ] Relevant role assignment and scope.
- [ ] Authorized access test result.
- [ ] Denied access test result, if performed.
- [ ] Encryption setting.
- [ ] Cleanup confirmation.

## Definitions

- **Storage Account:** An Azure resource that provides storage services such as blobs, files, queues, and tables.
- **Blob:** An object used to store unstructured data.
- **Anonymous access:** Access that does not require the requester to authenticate.
- **Data-plane role:** A permission that controls access to stored data rather than management of the Azure resource itself.
- **Encryption at rest:** Protection applied to stored data while it is persisted on storage media.
- **Storage firewall:** Network rules that restrict which sources can reach a storage service.

## Cost and safety

Use a small amount of synthetic data and a standard low-cost configuration. Review current pricing and redundancy options before deployment. Delete test data and the Storage Account if it is no longer needed. Never upload real personal or confidential information.