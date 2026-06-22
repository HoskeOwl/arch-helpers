# Arch Helpers

A collection of tools and scripts for working with Arch Linux in cloud environments, particularly focused on Yandex Cloud deployment and image management.

## 🚀 Features

- **Secure Packer Templates**: Build hardened Arch Linux images with security best practices
- **Cloud Image Fixes**: Fix datasource issues in Arch Linux QCOW2 cloud images
- **Firewall Configuration**: Pre-configured nftables rules with rate limiting and DDoS protection
- **SSH Hardening**: Modern cryptographic settings and security configurations
- **Automated Cleanup**: Secure cleanup scripts to remove sensitive data from images

## 📁 Project Structure

```
arch-helpers/
├── yandex-cloud/
│   ├── packer/docker/          # Packer templates for building Arch images
│   │   ├── base.pkr.hcl        # Main Packer configuration
│   │   ├── run.sh              # Build script with environment validation
│   │   ├── scripts/            # Provisioning scripts
│   │   └── config/             # System configuration files
│   └── qcow2-datasource-fix/   # Cloud image preparation tools
│       ├── get_stable_image.sh # Download latest Arch cloud image
│       ├── prepare.sh          # Fix datasource issues
│       └── make_image_from_s3.sh # Create Yandex Cloud images
└── README.md
```

## 🛠️ Quick Start

### Building Arch Linux Images with Packer

1. **Set up environment variables:**
```bash
export YC_BUILD_FOLDER_ID="your-folder-id"
export YC_BUILD_SERVICE_ACCOUNT_SECRET="/path/to/service-account-key.json"
export YC_BUILD_SUBNET="your-subnet-id"
export YC_ZONE="your-zone"
```

2. **Run the build:**
```bash
cd yandex-cloud/packer/docker/
./run.sh
```

### Preparing Cloud Images

1. **Download latest Arch image:**
```bash
cd yandex-cloud/qcow2-datasource-fix/
./get_stable_image.sh
```

2. **Fix datasource issues:**
```bash
sudo ./prepare.sh
```

3. **Create Yandex Cloud image:**
```bash
export FOLDER_ID="your-folder-id"
export PROFILE="your-yc-profile"
./make_image_from_s3.sh "https://s3.example.com/path/to/image.qcow2"
```

## 🔒 Security Features

### Packer Template Security
- **Environment validation**: All required variables are checked before build
- **Secure SSH configuration**: Modern crypto algorithms and key exchange methods
- **Hardened firewall**: nftables rules with rate limiting and DDoS protection
- **Cleanup automation**: Removes sensitive data and temporary files
- **Error handling**: Comprehensive error checking and logging

### Firewall Configuration
- Rate limiting on HTTP/HTTPS services (100 requests/minute)
- SSH brute force protection with temporary blocking
- ICMP rate limiting to prevent ping floods
- Docker network isolation rules
- IPv4 and IPv6 support

### SSH Hardening
- **Key Exchange**: Curve25519, ECDH with NIST curves
- **Ciphers**: ChaCha20-Poly1305, AES-GCM, AES-CTR
- **MACs**: HMAC-SHA2 with extended truncation
- **Authentication**: Public key only, no password authentication
- **Root login**: Disabled for security

## 📋 Requirements

### For Packer Builds
- [Packer](https://www.packer.io/) >= 1.7.0
- [Yandex Cloud CLI](https://yandex.cloud/en/docs/cli/quickstart) (`yc`)
- Valid Yandex Cloud service account with compute permissions

### For Image Preparation
- Root privileges
- NBD kernel module (`modprobe nbd`)
- qemu-nbd utility
- S3-compatible storage access

## 🔧 Configuration

### Environment Variables

#### Packer Build (`run.sh`)
| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `YC_BUILD_FOLDER_ID` | Yandex Cloud folder ID | — | Yes |
| `YC_BUILD_SERVICE_ACCOUNT_SECRET` | Path to service account key file | — | Yes |
| `YC_BUILD_SUBNET` | Subnet ID for build instance | — | Yes |
| `YC_ZONE` | Availability zone | — | Yes |
| `YC_IMAGE_DESCRIPTION` | Description of the resulting image | `arch` | No |
| `YC_IMAGE_FAMILY` | Image family of the resulting image | `arch` | No |
| `YC_IMAGE_NAME` | Name of the resulting image | `arch-docker-<timestamp>` | No |
| `YC_SOURCE_IMAGE_FAMILY` | Source image family to build from | `arch-docker` | No |
| `YC_SOURCE_IMAGE_FOLDER_ID` | Folder ID to look up the source image | `$YC_BUILD_FOLDER_ID` | No |
| `DEBUG` | Enable debug mode | — | No |

#### Image Preparation
| Variable | Description | Default |
|----------|-------------|---------|
| `IMG_URL` | Image download URL | `https://geo.mirror.pkgbuild.com/images/latest` |
| `IMG_PATH` | Local image directory | `./images` |
| `IMG_NAME` | Image filename | `Arch-Linux-x86_64-cloudimg.qcow2` |
| `FOLDER_ID` | Yandex Cloud folder ID | Required |
| `PROFILE` | Yandex Cloud CLI profile | Required |

## 🚨 Security Considerations

- **Service Account Keys**: Store securely and rotate regularly
- **Network Access**: Ensure build instances have minimal network access
- **Image Verification**: Always verify downloaded images using checksums
- **Cleanup**: The cleanup scripts remove sensitive data but verify before deployment
- **Firewall Rules**: Review and adjust rate limits based on your needs

## 🐛 Troubleshooting

### Common Issues

1. **Environment variable errors**: Ensure all required variables are set and valid
2. **Permission denied**: Some scripts require root privileges
3. **NBD mount failures**: Ensure NBD kernel module are available for the kernel
4. **Yandex Cloud API errors**: Verify credentials and permissions

### Debug Mode

Enable debug mode for detailed output:
```bash
DEBUG=1 ./run.sh
```

## 📚 Documentation

- [Yandex Cloud Packer Documentation](https://yandex.cloud/en/docs/tutorials/infrastructure-management/packer-quickstart)
- [Arch Linux Cloud Images](https://archlinux.org/download/)
- [nftables Documentation](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License Version 2.0 - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [arch-boxes](https://github.com/HoskeOwl/arch-boxes) - Arch Linux box building scripts
- [Yandex Cloud Documentation](https://yandex.cloud/en/docs)
- [Arch Linux Wiki](https://wiki.archlinux.org/)

---

**⚠️ Warning**: These scripts modify system configurations and create cloud resources. Always test in a safe environment before production use.
