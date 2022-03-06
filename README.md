<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD">
  </a>

<h3 align="center">Terraformed-WSRV-SSO-NXTCLD</h3>

  <p align="center">
    WSRV ADDS/ADFS - Nextcloud installation & configuration with Terraform
    <br />
    <a href="https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD/issues">Report Bug</a>
    ·
    <a href="https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#ad-synchro">AD Synchro</a></li>
        <li><a href="#sso-implementation">SSO Implementation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

WSRV ADDS/ADFS - Nextcloud installation & configuration with Terraform.

Created for the MSI formation at CESI.

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Terraform](https://www.terraform.io/)
* [Powershell](https://docs.microsoft.com/fr-fr/powershell/scripting/overview?view=powershell-7.2)
* [Bash](https://fr.wikipedia.org/wiki/Bourne-Again_shell)
* [Docker](https://www.docker.com/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

```
  Terraform
  AWS Environnment
  Admin account on AWS
  Git
  AWS CLI on your computer
```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD.git
   ```
2. Change vars.tf / .tfvars with your AWS keys
3. Change the AD variables in the .ps1
   ```powershell
   $DomainNameDNS = "example.fr"
   $DomainNameNetbios = "EXAMPLE"
   ```
4. Change the variable for the local admin (optionnal)
5. Create an SSH key pair for AWS with AWS CLI & Powershell
  ```powershell
  (New-EC2KeyPair -KeyName "my-key-pair" -KeyType "rsa").KeyMaterial | Out-File -Encoding ascii -FilePath C:\path\mykey.pem
  ```
6. Run Terraform
   ```sh
   terraform init
   terraform plan
   terraform apply
   ```
7. Once the installation with Terraform is complete (about 7min)

#### Nextcloud :
  
  You can now access to the Nextcloud part to : `https:\\AWS_INSTANCE_PUBLIC_IP:8082` and create your admin account.
  
#### Windows Server :
  
  Based on the deploiement, 4 powershell scripts are imported on the WSRV machine.
  
  Here's the process :
  
   ```
   1 - script_runscript.ps1
   2 - script_installadds.ps1 (Auto Reboot)
   3 - script_adds.ps1 (Auto Reboot)
   4 - script_adfs.ps1
   ```

So, you will have to connect a first time with the Administrator Account and wait till the reboot.

Then, reconnect to the instance with the Administrator Account and (re)wait till the reboot.

And to finish reconnect to the instance with `DOMAIN\Administrator` to complete the installation for the ADFS.

You'll now have a ADDS/ADFS configured Windows Server to connect at your Nextcloud instance.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

### AD Synchro

You can connect Nextcloud throught your AD to connect users.

Example for the configuration via the LDAP/AD integration plugin:

![image](https://user-images.githubusercontent.com/96118195/155697039-163045d0-85b0-490f-a4cb-34501cacbb86.png)

![image](https://user-images.githubusercontent.com/96118195/155697146-c40694ab-fef2-47d7-9b6a-ada70f3f3b43.png)

![image](https://user-images.githubusercontent.com/96118195/155697159-23bec24e-4084-46f6-b45f-1eb74220c66f.png)

![image](https://user-images.githubusercontent.com/96118195/155697179-5011cc2e-8c90-4d71-a01a-587c9c92660c.png)

### SSO Implementation

Set New Host for the Nextcloud instance in the DNS Manager.

![image](https://user-images.githubusercontent.com/96118195/156589495-8c8cdeba-ced8-4bb5-b00c-a0a8f1c8beb1.png)

The ``` script_get_x509.ps1 ``` is used to recover the certificate Token Signing so at the end of the WSRV installation there will be a .pem on the Administrator Desktop.

Open your `adfs_pem.pem` and copy everything in it.

In Nextcloud, install the SSO plugin.

![image](https://user-images.githubusercontent.com/96118195/156591681-e9145ce1-9788-4aac-a265-2d78193bc250.png)

And go into `Settings -> SSO & SAML authentication` and click on `Use Build Authentication`.

Set the variable with your key and domain, etc...

![image](https://user-images.githubusercontent.com/96118195/156592504-4f6aa04e-204f-45dd-be8b-5c58c8e59ce9.png)

Then click on `Download Metadata XML`

Return on Windows and click on `Add Relying Party Trust` and import the metadata and click on next till the end.

![image](https://user-images.githubusercontent.com/96118195/156593108-79d6c4c6-864e-42f9-aa36-67712eda48cf.png)

Then click on `Edit Claim Issuance Policy` and add a rule.

![image](https://user-images.githubusercontent.com/96118195/156593372-673554f9-101d-4d36-8797-652868c42c86.png)

Set the same variable as mine and click on Finish.

![image](https://user-images.githubusercontent.com/96118195/156593579-bf4d63d1-52db-46b3-908c-69ee733a7771.png)

Logout on Nextcloud and click on `SSO & SAML log in` and log in.

![image](https://user-images.githubusercontent.com/96118195/156594218-9502454d-37f9-4ab3-bcd7-56737152a24b.png)

Now, your logged with your user ! Thanks to SSO ! :D

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

DERUWEZ Florian - [@Fleorens](https://twitter.com/Fleorens) - florian.deruwez@outlook.com

Project Link: [https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD](https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors//Fleorens/Terraformed-WSRV-SSO-NXTCLD.svg?style=for-the-badge
[contributors-url]: https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo_name.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo_name/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo_name.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo_name/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo_name.svg?style=for-the-badge
[issues-url]: https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD/issues
[license-shield]: https://img.shields.io/github/license/Fleorens/Terraformed-WSRV-SSO-NXTCLD.svg?style=for-the-badge
[license-url]: https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/florian-deruwez-477769183/
[product-screenshot]: images/screenshot.png
