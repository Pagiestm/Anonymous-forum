# Changelog

## [1.4.0](https://github.com/Pagiestm/Anonymous-forum/compare/v1.3.0...v1.4.0) (2025-10-19)


### Features

* add Elastic IP resources for database and API, update user data scripts to reflect new IPs ([818abb8](https://github.com/Pagiestm/Anonymous-forum/commit/818abb8428a5d61f4b6c902f91291a980bb132ec))
* enhance documentation for CI/CD workflows and Terraform deployment ([920e018](https://github.com/Pagiestm/Anonymous-forum/commit/920e0189ef46909bfa842f4b564ea24d80baba3d))
* implement IAM roles and policies for EC2 instances to access SSM Parameter Store ([852683c](https://github.com/Pagiestm/Anonymous-forum/commit/852683cce8ac23624a1d8b3e0459cf73dd0aef9c))


### Bug Fixes

* move AWS credentials configuration step to the correct position in Terraform deployment workflow ([9c8e922](https://github.com/Pagiestm/Anonymous-forum/commit/9c8e922d8ccd0012a0e3387326256c2f4b65a42d))
* remove AWS credentials configuration step from Terraform deployment workflow ([06f8ea4](https://github.com/Pagiestm/Anonymous-forum/commit/06f8ea43b2a665775954b172e2b16ef31d1bf647))
* remove unnecessary domain attribute from Elastic IP resources ([9594f22](https://github.com/Pagiestm/Anonymous-forum/commit/9594f221922a7cc989bd45c76ba01aa374ae29c6))
* update Terraform Cloud organization to match production environment ([9a671f9](https://github.com/Pagiestm/Anonymous-forum/commit/9a671f9f71fc7d88af3bdedae1fc497cb6b36593))

## [1.3.0](https://github.com/Pagiestm/Anonymous-forum/compare/v1.2.0...v1.3.0) (2025-10-18)


### Features

* add Terraform deployment workflow with manual action options ([f05ca61](https://github.com/Pagiestm/Anonymous-forum/commit/f05ca6189fee3c1a07ff270ad42156c5a392c645))
* update AWS and Terraform Cloud credentials configuration in deployment workflow ([d092bdf](https://github.com/Pagiestm/Anonymous-forum/commit/d092bdf6458fa6a1c2f8d70e142fd0b806e4e8a1))


### Bug Fixes

* remove trailing newline in Terraform Destroy step ([01b1d21](https://github.com/Pagiestm/Anonymous-forum/commit/01b1d218f18dfacf6fb93cbf66d92587ade632e2))

## [1.2.0](https://github.com/Pagiestm/Anonymous-forum/compare/v1.1.1...v1.2.0) (2025-10-15)


### Features

* add Terraform deployment documentation and update user data scripts for public IP usage ([f75a644](https://github.com/Pagiestm/Anonymous-forum/commit/f75a644000a8a72c44ee9fce631a9a6fb48add53))


### Bug Fixes

* strip CRLF from generated nginx conf and print API_HOST for debugging ([411678b](https://github.com/Pagiestm/Anonymous-forum/commit/411678b0c9998f41bac2d516f21dbb166d10b196))

## [1.1.1](https://github.com/Pagiestm/Anonymous-forum/compare/v1.1.0...v1.1.1) (2025-05-14)


### Bug Fixes

* remove unnecessary padding from body in style.css ([714b9cd](https://github.com/Pagiestm/Anonymous-forum/commit/714b9cdcc446f7a4608071710bdc02a2039313f3))
* remove unnecessary padding from body in style.css ([f886b58](https://github.com/Pagiestm/Anonymous-forum/commit/f886b589968f2fb4790ad342effebbba524771f6))

## [1.1.0](https://github.com/Pagiestm/Anonymous-forum/compare/v1.0.4...v1.1.0) (2025-04-16)


### Features

* remove release-it configuration and related scripts from packag… ([79cd934](https://github.com/Pagiestm/Anonymous-forum/commit/79cd93428d32b465ce22eede2a4628a61424f2ef))
* remove release-it configuration and related scripts from package.json ([e023041](https://github.com/Pagiestm/Anonymous-forum/commit/e023041807ba6facdde9fe219691482dedc70425))


### Bug Fixes

* correct workflow name and add missing permissions in release.yml ([b4d6f52](https://github.com/Pagiestm/Anonymous-forum/commit/b4d6f529a56a303b329c8a46603bbf096a9a9314))
* correct workflow name and add missing permissions in release.yml ([7b38957](https://github.com/Pagiestm/Anonymous-forum/commit/7b38957425ac213b6cf32401cc44dfe0f31cc950))
