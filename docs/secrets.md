# Login secrets and SOPS

`secrets/login.sops.yaml` is SOPS-encrypted YAML for this instance. SOPS uses the age public recipient in `.sops.yaml`; values and the integrity MAC are encrypted. This is encryption, not base64 encoding.

The generated login is a planned credential until the document's installation status says it was applied and verified. Never assume generating an encrypted password changed ARM. Stock ARM's initial account must be changed after database initialization, and an actual login with the new password must succeed before recording it as installed.

The document holds the desired administrator username/password, upstream bootstrap credentials, local dashboard address, credential application status, and unset optional integration keys. MakeMKV registration and metadata-provider keys are not invented or fetched on the operator's behalf. If needed, obtain them from the operator and add them encrypted. Do not store the sudo password, GitHub token, or SSH private key here.

The age identity is `/home/louis/.config/sops/age/helix-arm.txt`, mode 0600. Only its public recipient is committed. Back up the private identity outside this repository; without it or another authorized recipient, the encrypted login cannot be recovered.

SOPS v3.13.3 was downloaded from its official release and checked against its release SHA-256 list. No Ubuntu SOPS candidate was present. The verified executable is installed at `/home/louis/.local/bin/sops`. Ubuntu age 1.2.1 was downloaded and extracted, then `age` and `age-keygen` were installed under `/home/louis/.local/bin`; no apt package transaction was needed for these user-local tools. Downloaded packages and validation CLIs remain under `/srv/b70-encode/tmp/helix-arm-tools`.

To display credentials locally in an operator-controlled terminal:

```bash
export SOPS_AGE_KEY_FILE=/home/louis/.config/sops/age/helix-arm.txt
/home/louis/.local/bin/sops decrypt secrets/login.sops.yaml
```

Do not paste decrypted output into tickets or agent logs. For future edits, use `sops edit` with the same key environment and a trusted editor, then verify a decrypt round-trip without logging values. Only files matching `secrets/*.sops.yaml` are allowed by this repository's ignore rules; explicitly stage named encrypted files after checking their SOPS metadata. Never commit the identity file.

## Access and initialization

Compose binds the dashboard to `127.0.0.1:8080` on the guest. From the operator's workstation, forward it with `ssh -N -L 8080:127.0.0.1:8080 louis@b70-encode-matrix`, then open `http://127.0.0.1:8080`. SSH uses the existing account authentication and is separate from ARM's administrator login. No TLS/reverse-proxy or public listener is configured.

Initialize the database via upstream `/setup` if prompted, sign in with the encrypted bootstrap credential, and use `/update_password` to set the encrypted planned password. Verify logout/login and a failed attempt with the former password. Then change the encrypted application status and add a sanitized acceptance record.

Source review of this release found a fixed Flask session signing key in `arm/ui/__init__.py`, with no supported configuration override. A strong administrator password does not change that key. This stock trial remains loopback-only; wider dashboard exposure needs a separate upstream/configuration review. No custom application patch is applied here.

References: [SOPS documentation](https://getsops.io/docs/) and [official SOPS v3.13.3 release](https://github.com/getsops/sops/releases/tag/v3.13.3).
