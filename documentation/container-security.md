# Container Security Lab

## Objective

Demonstrate basic container security practices by inspecting a container image, scanning it for known vulnerabilities, reviewing its configuration, and rebuilding or updating it to address selected findings.

This exercise is intentionally local. Do not deploy AKS or another managed Kubernetes cluster for this project; it is unnecessary for the learning objective and can create avoidable costs.

## Prerequisites

- Docker Desktop or another supported local Docker Engine installation.
- Trivy installed locally.
- A test image from a trusted publisher.
- Sufficient local disk space.

Do not begin by running an unknown image with elevated privileges or mounting sensitive host directories.

## Exercise workflow

1. Record Docker and Trivy versions.
2. Select a small, trusted test image and record its exact tag or digest.
3. Inspect image metadata and declared user, exposed ports, and entrypoint where available.
4. Run a Trivy image scan and save sanitized output.
5. Review findings by severity and identify the affected package and fixed version, if supplied.
6. Update the base image or affected package using a supported version.
7. Rebuild the image and scan it again.
8. Compare before/after findings and document what remains.

## Security review checklist

- [ ] Prefer trusted, maintained base images.
- [ ] Pin a specific image version or digest for repeatability.
- [ ] Avoid running as root when the application supports a non-root user.
- [ ] Do not embed passwords, API keys, or tokens in image layers.
- [ ] Minimize unnecessary packages and installed tools.
- [ ] Review exposed ports and runtime privileges.
- [ ] Keep the image updated and rescan after changes.
- [ ] Record the actual scan output and retest result.

## Evidence to publish

- Docker and Trivy versions.
- Image name and tag/digest.
- Sanitized initial scan summary.
- One or more findings explained in plain language.
- Remediation and rebuild notes.
- Sanitized follow-up scan summary.
- Limitations, including any findings that remain unresolved.

## Definitions

- **Container:** An isolated process environment that packages an application with its dependencies.
- **Image:** A template used to create containers.
- **Base image:** The starting image used to build another image.
- **Layer:** A reusable filesystem change that forms part of an image.
- **Trivy:** An open-source scanner that can identify known vulnerabilities in container images.
- **CVE:** Common Vulnerabilities and Exposures; a public identifier for a disclosed vulnerability.
- **Non-root user:** A user account without the full privileges of the root account.

## Safety and cost

Run this lab locally. Do not upload proprietary images or secrets to public scanning services. A local scanner may still need internet access to download vulnerability databases; check its database update behavior and avoid including credentials in commands or screenshots.