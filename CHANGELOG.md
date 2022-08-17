# Changelog

All notable changes to this project will be documented in this file.

## [1.9.0](https://github.com/wandb/terraform-google-wandb/compare/v1.8.0...v1.9.0) (2022-08-17)


### Features

* Add local restore option ([#35](https://github.com/wandb/terraform-google-wandb/issues/35)) ([67bf73c](https://github.com/wandb/terraform-google-wandb/commit/67bf73c8f1075370a17a9d400f23a091d9e284a5))

## [1.8.0](https://github.com/wandb/terraform-google-wandb/compare/v1.7.0...v1.8.0) (2022-08-16)


### Features

* Add oidc secret as variable ([#34](https://github.com/wandb/terraform-google-wandb/issues/34)) ([fdefb03](https://github.com/wandb/terraform-google-wandb/commit/fdefb038d23a2b95e3e26230a1949c313d16af43))

## [1.7.0](https://github.com/wandb/terraform-google-wandb/compare/v1.6.3...v1.7.0) (2022-08-16)


### Features

* Add sort buffer size ([#28](https://github.com/wandb/terraform-google-wandb/issues/28)) ([0b3e90a](https://github.com/wandb/terraform-google-wandb/commit/0b3e90a9deb17ec3c8d627bf1b458976cc5c9f87))

### [1.6.3](https://github.com/wandb/terraform-google-wandb/compare/v1.6.2...v1.6.3) (2022-08-13)


### Bug Fixes

* Resolved mis-named network variable ([#33](https://github.com/wandb/terraform-google-wandb/issues/33)) ([50cd769](https://github.com/wandb/terraform-google-wandb/commit/50cd769ed3fef6e0e1e36409e1ebce558fbec6aa))

### [1.6.2](https://github.com/wandb/terraform-google-wandb/compare/v1.6.1...v1.6.2) (2022-08-12)


### Bug Fixes

* Bump wandb kubernetes module to 1.2.0 ([#32](https://github.com/wandb/terraform-google-wandb/issues/32)) ([2652bda](https://github.com/wandb/terraform-google-wandb/commit/2652bdacde06542fb0d01abee9a36cbd932628b0))

### [1.6.1](https://github.com/wandb/terraform-google-wandb/compare/v1.6.0...v1.6.1) (2022-08-12)


### Bug Fixes

* Add log writer permissions to SA account ([#31](https://github.com/wandb/terraform-google-wandb/issues/31)) ([682f658](https://github.com/wandb/terraform-google-wandb/commit/682f65848e0a3a95660a1dc20e5d28ceba549889))

## [1.6.0](https://github.com/wandb/terraform-google-wandb/compare/v1.5.1...v1.6.0) (2022-08-10)


### Features

* Add disable legacy endpoints ([#29](https://github.com/wandb/terraform-google-wandb/issues/29)) ([f776134](https://github.com/wandb/terraform-google-wandb/commit/f7761343302ae921a797d2a7e8beb3aebcec2ae7))

### [1.5.1](https://github.com/wandb/terraform-google-wandb/compare/v1.5.0...v1.5.1) (2022-07-29)


### Bug Fixes

* CORS response headers on bucket ([0defaa4](https://github.com/wandb/terraform-google-wandb/commit/0defaa4c9a68944f09500d1422f63c92461ad10a))

## [1.5.0](https://github.com/wandb/terraform-google-wandb/compare/v1.4.5...v1.5.0) (2022-07-14)


### Features

* Deploy into existing network ([#26](https://github.com/wandb/terraform-google-wandb/issues/26)) ([6aff8b7](https://github.com/wandb/terraform-google-wandb/commit/6aff8b74779255c4fa86f47458c1c9cc3ee3de3a))

### [1.4.5](https://github.com/wandb/terraform-google-wandb/compare/v1.4.4...v1.4.5) (2022-07-12)


### Bug Fixes

* Race condition with load balancer ([#25](https://github.com/wandb/terraform-google-wandb/issues/25)) ([6f116c6](https://github.com/wandb/terraform-google-wandb/commit/6f116c629c029d06a39312b18d26950d7a7002cc))

### [1.4.4](https://github.com/wandb/terraform-google-wandb/compare/v1.4.3...v1.4.4) (2022-07-12)


### Bug Fixes

* notification topic not include project name ([#24](https://github.com/wandb/terraform-google-wandb/issues/24)) ([46c7711](https://github.com/wandb/terraform-google-wandb/commit/46c7711bdac5bab95f48ce945937123f8e80070a))

### [1.4.3](https://github.com/wandb/terraform-google-wandb/compare/v1.4.2...v1.4.3) (2022-06-24)


### Bug Fixes

* Explicitly disable client certificate auth (deprecated by kubernetes) ([#23](https://github.com/wandb/terraform-google-wandb/issues/23)) ([0a16247](https://github.com/wandb/terraform-google-wandb/commit/0a16247d98d2437002faac9b95210ca92ad78b13))

### [1.4.2](https://github.com/wandb/terraform-google-wandb/compare/v1.4.1...v1.4.2) (2022-05-27)


### Bug Fixes

* Default to n1-standard-4 machines ([#21](https://github.com/wandb/terraform-google-wandb/issues/21)) ([36d7a8e](https://github.com/wandb/terraform-google-wandb/commit/36d7a8eaa1f94abc2df698f542c14e4912d3a2eb))

### [1.4.1](https://github.com/wandb/terraform-google-wandb/compare/v1.4.0...v1.4.1) (2022-05-11)


### Bug Fixes

* Add labels and health-check logging ([#19](https://github.com/wandb/terraform-google-wandb/issues/19)) ([40fd527](https://github.com/wandb/terraform-google-wandb/commit/40fd527f924f3daa283ffbd5902b98ea79525e1d))
* Update redis TTL ([#20](https://github.com/wandb/terraform-google-wandb/issues/20)) ([f56cfff](https://github.com/wandb/terraform-google-wandb/commit/f56cfffae1b6d540d76eda511c3234d3a81f83b1))

## [1.4.0](https://github.com/wandb/terraform-google-wandb/compare/v1.3.1...v1.4.0) (2022-05-05)


### Features

* Use Redis ([#17](https://github.com/wandb/terraform-google-wandb/issues/17)) ([3f08d7b](https://github.com/wandb/terraform-google-wandb/commit/3f08d7b044e97d3fc3ccef1f659aabb196763bb3))

### [1.3.1](https://github.com/wandb/terraform-google-wandb/compare/v1.3.0...v1.3.1) (2022-05-04)


### Bug Fixes

* Reduce bucket name length ([#18](https://github.com/wandb/terraform-google-wandb/issues/18)) ([0bc04b5](https://github.com/wandb/terraform-google-wandb/commit/0bc04b56d0ecb32cc87109bffb6e851280f86e31))

## [1.3.0](https://github.com/wandb/terraform-google-wandb/compare/v1.2.1...v1.3.0) (2022-04-21)


### Features

* Bring your own bucket ([#12](https://github.com/wandb/terraform-google-wandb/issues/12)) ([1fc8a3d](https://github.com/wandb/terraform-google-wandb/commit/1fc8a3df9273f042b67ed0c74bac3fff43b10ec3))

### [1.2.1](https://github.com/wandb/terraform-google-wandb/compare/v1.2.0...v1.2.1) (2022-04-20)


### Bug Fixes

* Isolate token creator permissions to SA ([#10](https://github.com/wandb/terraform-google-wandb/issues/10)) ([2fd2d9c](https://github.com/wandb/terraform-google-wandb/commit/2fd2d9c6a68646cdf478668e6c8782d4b5ccde5a))

## [1.2.0](https://github.com/wandb/terraform-google-wandb/compare/v1.1.0...v1.2.0) (2022-04-16)


### Features

* Option to enable redis ([#11](https://github.com/wandb/terraform-google-wandb/issues/11)) ([1022cd6](https://github.com/wandb/terraform-google-wandb/commit/1022cd630ae68dac78afb8fa0d53e16b755e5279))

## [1.1.0](https://github.com/wandb/terraform-google-wandb/compare/v1.0.0...v1.1.0) (2022-04-11)


### Features

* Defaults to MySQL 8 ([#8](https://github.com/wandb/terraform-google-wandb/issues/8)) ([0babddf](https://github.com/wandb/terraform-google-wandb/commit/0babddfbbff718dd828dcfae9945db7429c2c290))


### Bug Fixes

* Generate random storage bucket using pet names ([#7](https://github.com/wandb/terraform-google-wandb/issues/7)) ([9491cb9](https://github.com/wandb/terraform-google-wandb/commit/9491cb916e91e19d184e7fedab7b109a8466e9dd))

## 1.0.0 (2022-03-25)


### Features

* Release V1 🥳 ([#6](https://github.com/wandb/terraform-google-wandb/issues/6)) ([4cffc00](https://github.com/wandb/terraform-google-wandb/commit/4cffc008c18c51ddbeb05cdf5db2d1ace8c0d59c))
