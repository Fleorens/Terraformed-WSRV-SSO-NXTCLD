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
    <li><a href="#usage">Usage</a></li>
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
```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD.git
   ```
2. Change vars.tf / .tfvars with your wish
3. Change the AD variables in the .ps1
   ```powershell
   $DomainNameDNS = "example.fr"
   $DomainNameNetbios = "EXAMPLE"
   ```
4. Create an SSH key pair for AWS
  ```powershell
  (New-EC2KeyPair -KeyName "my-key-pair" -KeyType "rsa").KeyMaterial | Out-File -Encoding ascii -FilePath C:\path\mykey.pem
  ```
5. Run Terraform
   ```sh
   terraform init
   terraform plan
   terraform apply
   ```
6. Once the installation with Terraform is complete (about 7min)

#### Nextcloud :
  
  You can now access to the Nextcloud part to : `http:\\AWS_INSTANCE_PUBLIC_IP:8080` and create your admin account.
  
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

You can connect Nextcloud throught your AD to connect users.

Example for the configuration via the LDAP/AD integration plugin:

![image](https://user-images.githubusercontent.com/96118195/155697039-163045d0-85b0-490f-a4cb-34501cacbb86.png)

![image](https://user-images.githubusercontent.com/96118195/155697146-c40694ab-fef2-47d7-9b6a-ada70f3f3b43.png)

![image](https://user-images.githubusercontent.com/96118195/155697159-23bec24e-4084-46f6-b45f-1eb74220c66f.png)

![image](https://user-images.githubusercontent.com/96118195/155697179-5011cc2e-8c90-4d71-a01a-587c9c92660c.png)

The part with the SSO will come after some improvements.

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

Distributed under the MIT License. See `LICENSE.md` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/Fleorens) - florian.deruwez@outlook.com

Project Link: [https://github.com/github_username/repo_name](https://github.com/Fleorens/Terraformed-WSRV-SSO-NXTCLD)

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
