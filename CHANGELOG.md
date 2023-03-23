# Changelog

All notable changes to this project will be documented in this file.

### [1.13.5](https://github.com/wandb/terraform-google-wandb/compare/v1.13.4...v1.13.5) (2023-03-23)


### Bug Fixes

* Enable MySQL connection ssl ([#63](https://github.com/wandb/terraform-google-wandb/issues/63)) ([2c2e1f6](https://github.com/wandb/terraform-google-wandb/commit/2c2e1f626a6da457674df61c8b371cfc0465c4fe))

### [1.13.4](https://github.com/wandb/terraform-google-wandb/compare/v1.13.3...v1.13.4) (2023-03-07)


### Bug Fixes

* Set MySQL default version to MYSQL_8_0_31 ([#57](https://github.com/wandb/terraform-google-wandb/issues/57)) ([16de6ca](https://github.com/wandb/terraform-google-wandb/commit/16de6cafac6d78fc4d94c520998cb30bc80fbdc9))

### [1.13.3](https://github.com/wandb/terraform-google-wandb/compare/v1.13.2...v1.13.3) (2023-03-02)


### Bug Fixes

* Regex check is invalid on database version ([#60](https://github.com/wandb/terraform-google-wandb/issues/60)) ([c5ac642](https://github.com/wandb/terraform-google-wandb/commit/c5ac642b08f42dad691c6af67b1ba37ab9f38eac))

### [1.13.2](https://github.com/wandb/terraform-google-wandb/compare/v1.13.1...v1.13.2) (2023-03-01)


### Bug Fixes

* Add back the default mysql version ([#54](https://github.com/wandb/terraform-google-wandb/issues/54)) ([5c001fa](https://github.com/wandb/terraform-google-wandb/commit/5c001fa58baea4b88e926fd0f0d400d2e8dcbd54))

### [1.13.1](https://github.com/wandb/terraform-google-wandb/compare/v1.13.0...v1.13.1) (2023-03-01)


### Bug Fixes

* Update mysql version ([#47](https://github.com/wandb/terraform-google-wandb/issues/47)) ([f7e9b87](https://github.com/wandb/terraform-google-wandb/commit/f7e9b87f123b2bb9f993361b80289b6a33b88707))

## [1.13.0](https://github.com/wandb/terraform-google-wandb/compare/v1.12.5...v1.13.0) (2023-02-28)


### Features

* Add module for secure storage connector ([#50](https://github.com/wandb/terraform-google-wandb/issues/50)) ([ea192ba](https://github.com/wandb/terraform-google-wandb/commit/ea192bafb9bc588e466b005d2f2238b09997352c))

### [1.12.5](https://github.com/wandb/terraform-google-wandb/compare/v1.12.4...v1.12.5) (2023-02-07)


### Bug Fixes

* Add additional database verisons ([#48](https://github.com/wandb/terraform-google-wandb/issues/48)) ([6526d7b](https://github.com/wandb/terraform-google-wandb/commit/6526d7b2c2b9ae729dd2fdc25118893a78dbecf0))

### [1.12.4](https://github.com/wandb/terraform-google-wandb/compare/v1.12.3...v1.12.4) (2023-02-02)


### Bug Fixes

* Update node pool image type ([#46](https://github.com/wandb/terraform-google-wandb/issues/46)) ([72e0ea7](https://github.com/wandb/terraform-google-wandb/commit/72e0ea700f1801e07d3cd0c19baa771b488c9a41))

### [1.12.3](https://github.com/wandb/terraform-google-wandb/compare/v1.12.2...v1.12.3) (2023-01-27)


### Bug Fixes

* Remove deperciated binary auth property ([#30](https://github.com/wandb/terraform-google-wandb/issues/30)) ([c48a551](https://github.com/wandb/terraform-google-wandb/commit/c48a551ca875d3926cb43e8d7bbd92fe59d1fa07))

### [1.12.2](https://github.com/wandb/terraform-google-wandb/compare/v1.12.1...v1.12.2) (2022-11-23)


### Bug Fixes

* Add project option to storage module ([#43](https://github.com/wandb/terraform-google-wandb/issues/43)) ([e95f86f](https://github.com/wandb/terraform-google-wandb/commit/e95f86fb2b26e5723d70914a4b780bdb5bbe8dcb))

### [1.12.1](https://github.com/wandb/terraform-google-wandb/compare/v1.12.0...v1.12.1) (2022-10-12)


### Bug Fixes

* Fix domain_name variable name in the example ([#40](https://github.com/wandb/terraform-google-wandb/issues/40)) ([96028d3](https://github.com/wandb/terraform-google-wandb/commit/96028d3287ceb47d0553cd3062b00e568f6fa19a))

## [1.12.0](https://github.com/wandb/terraform-google-wandb/compare/v1.11.7...v1.12.0) (2022-09-27)


### Features

* Adds code saving env variable ([#38](https://github.com/wandb/terraform-google-wandb/issues/38)) ([18df530](https://github.com/wandb/terraform-google-wandb/commit/18df53003a306f7b1f288ed94b1c63d1a005b67d))

### [1.11.7](https://github.com/wandb/terraform-google-wandb/compare/v1.11.6...v1.11.7) (2022-09-15)


### Bug Fixes

* split order of database strings ([b7ab0bf](https://github.com/wandb/terraform-google-wandb/commit/b7ab0bfe936cbfa20944db0c09f473f810781e0b))

### [1.11.6](https://github.com/wandb/terraform-google-wandb/compare/v1.11.5...v1.11.6) (2022-09-15)


### Bug Fixes

* Database recreation keepers ([3a29511](https://github.com/wandb/terraform-google-wandb/commit/3a2951154a1cadb2fa70e60549a9d37ca3807afa))
* Version references ([6edb800](https://github.com/wandb/terraform-google-wandb/commit/6edb800fc3f246a6d3d7ff34d110104dde77dfba))

### [1.11.5](https://github.com/wandb/terraform-google-wandb/compare/v1.11.4...v1.11.5) (2022-09-15)


### Bug Fixes

* Add Mysql 8.0.29 as an option ([7ab9619](https://github.com/wandb/terraform-google-wandb/commit/7ab961921aa928a37ae1ae6f77baaa53244fbfd0))

### [1.11.4](https://github.com/wandb/terraform-google-wandb/compare/v1.11.3...v1.11.4) (2022-09-15)


### Bug Fixes

* bump default mysql version ([3fa99a7](https://github.com/wandb/terraform-google-wandb/commit/3fa99a76f64c339e9a7f6a1d12d47e711569dead))

### [1.11.3](https://github.com/wandb/terraform-google-wandb/compare/v1.11.2...v1.11.3) (2022-09-15)


### Bug Fixes

* Database version nolonger changes database name ([ff96083](https://github.com/wandb/terraform-google-wandb/commit/ff96083c6c96581087a55f14a6053b95018ff149))

### [1.11.2](https://github.com/wandb/terraform-google-wandb/compare/v1.11.1...v1.11.2) (2022-09-15)


### Bug Fixes

* bump support mysql databases ([621a075](https://github.com/wandb/terraform-google-wandb/commit/621a075e735f6caba9d2ffe82a788eda6fd6e5a3))

### [1.11.1](https://github.com/wandb/terraform-google-wandb/compare/v1.11.0...v1.11.1) (2022-09-15)


### Bug Fixes

* Add mysql 8.0.28 as default ([05e2401](https://github.com/wandb/terraform-google-wandb/commit/05e2401231e1733208a7670d206d38ee9da898dc))

## [1.11.0](https://github.com/wandb/terraform-google-wandb/compare/v1.10.0...v1.11.0) (2022-09-08)


### Features

* Support for ip or cidr allow list ([#37](https://github.com/wandb/terraform-google-wandb/issues/37)) ([df49860](https://github.com/wandb/terraform-google-wandb/commit/df49860bd989886341b644e55ba8fd16494d1032))

## [1.10.0](https://github.com/wandb/terraform-google-wandb/compare/v1.9.0...v1.10.0) (2022-08-29)


### Features

* Add database and GKE instance types as configurable params ([#36](https://github.com/wandb/terraform-google-wandb/issues/36)) ([2f7dbb8](https://github.com/wandb/terraform-google-wandb/commit/2f7dbb822a76a0a622cf42024b13ce7c7aec8a40))

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
