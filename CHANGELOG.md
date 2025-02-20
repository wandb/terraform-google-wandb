# Changelog

All notable changes to this project will be documented in this file.

### [9.4.1](https://github.com/wandb/terraform-google-wandb/compare/v9.4.0...v9.4.1) (2025-02-20)


### Bug Fixes

* Redis gcp ca cert path correction ([#229](https://github.com/wandb/terraform-google-wandb/issues/229)) ([f0dca42](https://github.com/wandb/terraform-google-wandb/commit/f0dca42c400be3c0bdfb2b4a949df3ba49ca3fd7))

## [9.4.0](https://github.com/wandb/terraform-google-wandb/compare/v9.3.4...v9.4.0) (2025-02-19)


### Features

* INFRA-478 support for external redis, default off ([#228](https://github.com/wandb/terraform-google-wandb/issues/228)) ([25a3daf](https://github.com/wandb/terraform-google-wandb/commit/25a3daf61480479a230c6f3e3f4b3d3b8bc6a2a0))

### [9.3.4](https://github.com/wandb/terraform-google-wandb/compare/v9.3.3...v9.3.4) (2025-02-14)


### Bug Fixes

* Chunk out allowed cidrs ([#227](https://github.com/wandb/terraform-google-wandb/issues/227)) ([ff35a15](https://github.com/wandb/terraform-google-wandb/commit/ff35a15174cdc79cd5d4ddfc3d2a3e182f94534e))

### [9.3.3](https://github.com/wandb/terraform-google-wandb/compare/v9.3.2...v9.3.3) (2025-02-13)


### Bug Fixes

* Another trivial fix for releasebot ([#226](https://github.com/wandb/terraform-google-wandb/issues/226)) ([971976d](https://github.com/wandb/terraform-google-wandb/commit/971976d78d08080d8abb25211e3cfff22ee296f2))
* Trivial fix for semantic bot ([#225](https://github.com/wandb/terraform-google-wandb/issues/225)) ([466af49](https://github.com/wandb/terraform-google-wandb/commit/466af499bbf89bf858b4b798d2aa489f47564b3d))


### Reverts

* INFRA-383 toggle for core-managed redis ([#224](https://github.com/wandb/terraform-google-wandb/issues/224)) ([c628884](https://github.com/wandb/terraform-google-wandb/commit/c628884b99c367c3683b6c71e76294a34cf4c9db))

### [9.3.2](https://github.com/wandb/terraform-google-wandb/compare/v9.3.1...v9.3.2) (2025-02-13)


### Bug Fixes

* The default privatelink and allowed cidrs dont work as is ([#223](https://github.com/wandb/terraform-google-wandb/issues/223)) ([f0cfb5c](https://github.com/wandb/terraform-google-wandb/commit/f0cfb5cf616c23fefd4c27d184c008096dd8a23b))


### Features

## [9.2.0](https://github.com/wandb/terraform-google-wandb/compare/v9.1.3...v9.2.0) (2025-02-07)


### Features

* Enable an IP allow list ([#218](https://github.com/wandb/terraform-google-wandb/issues/218)) ([68dc80b](https://github.com/wandb/terraform-google-wandb/commit/68dc80b829fae4787ee1fc5ec9ccdc0a4d92bd38))

### [9.1.3](https://github.com/wandb/terraform-google-wandb/compare/v9.1.2...v9.1.3) (2025-02-06)


### Bug Fixes

* Remove description since it seems to force recreates when nothing changes ([#220](https://github.com/wandb/terraform-google-wandb/issues/220)) ([6ff7b94](https://github.com/wandb/terraform-google-wandb/commit/6ff7b94d297e5b4f301614ad93260930ff8c146b))

### [9.1.2](https://github.com/wandb/terraform-google-wandb/compare/v9.1.1...v9.1.2) (2025-02-06)


### Bug Fixes

* Abandon service network connections ([#216](https://github.com/wandb/terraform-google-wandb/issues/216)) ([8620198](https://github.com/wandb/terraform-google-wandb/commit/8620198397da5ffd4505a90cc3aa4600bf8b6e19))

### [9.1.1](https://github.com/wandb/terraform-google-wandb/compare/v9.1.0...v9.1.1) (2025-02-04)


### Bug Fixes

* Forwarding rule names need to be unique ([#219](https://github.com/wandb/terraform-google-wandb/issues/219)) ([0db345c](https://github.com/wandb/terraform-google-wandb/commit/0db345cf0336e6616402429281e7ac04d95e79f8))

## [9.1.0](https://github.com/wandb/terraform-google-wandb/compare/v9.0.4...v9.1.0) (2025-02-03)


### Features

* Adding bigtable and pubsub support for GCP ([#178](https://github.com/wandb/terraform-google-wandb/issues/178)) ([5b3e862](https://github.com/wandb/terraform-google-wandb/commit/5b3e862ccbd3b5e9575255bc5999a812f74a4615))

### [9.0.4](https://github.com/wandb/terraform-google-wandb/compare/v9.0.3...v9.0.4) (2025-02-03)


### Bug Fixes

* Only forward the configured subdomains of googleapis.com ([#217](https://github.com/wandb/terraform-google-wandb/issues/217)) ([e74a45d](https://github.com/wandb/terraform-google-wandb/commit/e74a45d8083fe84fc43bbf019cc0b381ec8c4e1f))

### [9.0.3](https://github.com/wandb/terraform-google-wandb/compare/v9.0.2...v9.0.3) (2025-01-30)


### Bug Fixes

* Non-global PSC forwarding rules can have labels. ([#215](https://github.com/wandb/terraform-google-wandb/issues/215)) ([0e11a3c](https://github.com/wandb/terraform-google-wandb/commit/0e11a3c0a0b326f60a907f87314519c0555dc1ca))

### [9.0.2](https://github.com/wandb/terraform-google-wandb/compare/v9.0.1...v9.0.2) (2025-01-30)


### Bug Fixes

* Not sure why that got added, but its wrong ([#214](https://github.com/wandb/terraform-google-wandb/issues/214)) ([675af62](https://github.com/wandb/terraform-google-wandb/commit/675af62c876086cb10684f115a60bb71768168be))

### [9.0.1](https://github.com/wandb/terraform-google-wandb/compare/v9.0.0...v9.0.1) (2025-01-30)


### Bug Fixes

* Remove duplicate variable caused by merge issues ([#213](https://github.com/wandb/terraform-google-wandb/issues/213)) ([c1e68ec](https://github.com/wandb/terraform-google-wandb/commit/c1e68ec3a027e97e75010ad2ebe2ad2194f282d9))

## [9.0.0](https://github.com/wandb/terraform-google-wandb/compare/v8.0.4...v9.0.0) (2025-01-30)


### ⚠ BREAKING CHANGES

* Force connections to Google's APIs to go through a PSC (#212)

### Features

* Force connections to Google's APIs to go through a PSC ([#212](https://github.com/wandb/terraform-google-wandb/issues/212)) ([aa8399f](https://github.com/wandb/terraform-google-wandb/commit/aa8399f2b6769193a05d6f710116900d49f3f4d5))

### [8.0.4](https://github.com/wandb/terraform-google-wandb/compare/v8.0.3...v8.0.4) (2025-01-24)


### Bug Fixes

* Console identity value if using workload id ([#211](https://github.com/wandb/terraform-google-wandb/issues/211)) ([64b4471](https://github.com/wandb/terraform-google-wandb/commit/64b44719627a4da5ecd2584fd5aedec6217cbdc3))

### [8.0.3](https://github.com/wandb/terraform-google-wandb/compare/v8.0.2...v8.0.3) (2025-01-21)


### Bug Fixes

* Prevent diffs appearing when nothing has changed in PSC configs ([#209](https://github.com/wandb/terraform-google-wandb/issues/209)) ([60597e4](https://github.com/wandb/terraform-google-wandb/commit/60597e4a5d21e861c31fd53234912935d580ef48))
* Previous merge did not trigger release ([#210](https://github.com/wandb/terraform-google-wandb/issues/210)) ([205e332](https://github.com/wandb/terraform-google-wandb/commit/205e332f864611eefe524664e6b381adf1027cb5))

### [8.0.2](https://github.com/wandb/terraform-google-wandb/compare/v8.0.1...v8.0.2) (2025-01-21)


### Bug Fixes

* Set the default value or it causes a diff and recreate in TF ([#208](https://github.com/wandb/terraform-google-wandb/issues/208)) ([c7dc4dd](https://github.com/wandb/terraform-google-wandb/commit/c7dc4ddaa4e87df495fbde059cd1fe07d595f973))

### [8.0.1](https://github.com/wandb/terraform-google-wandb/compare/v8.0.0...v8.0.1) (2025-01-16)


### Bug Fixes

* Adding missing service account ([#207](https://github.com/wandb/terraform-google-wandb/issues/207)) ([527d4db](https://github.com/wandb/terraform-google-wandb/commit/527d4dbbc3856796c4fea4060c2c2c184c81a4e5))

## [8.0.0](https://github.com/wandb/terraform-google-wandb/compare/v7.0.4...v8.0.0) (2025-01-13)


### ⚠ BREAKING CHANGES

* Use defaultBucket (#189) *BREAKING CHANGE*

### Features

* Use defaultBucket ([#189](https://github.com/wandb/terraform-google-wandb/issues/189)) *BREAKING CHANGE* ([8306b7a](https://github.com/wandb/terraform-google-wandb/commit/8306b7a6dcb4e5ad678bb0c63a87128c3eeb797d))

### [7.0.4](https://github.com/wandb/terraform-google-wandb/compare/v7.0.3...v7.0.4) (2025-01-13)


### Bug Fixes

* Reenable local_infile setting for cloudSQL database ([#205](https://github.com/wandb/terraform-google-wandb/issues/205)) ([80b20f6](https://github.com/wandb/terraform-google-wandb/commit/80b20f66bd210936118cfad277a99234d3096e5f))

### [7.0.3](https://github.com/wandb/terraform-google-wandb/compare/v7.0.2...v7.0.3) (2025-01-10)


### Bug Fixes

* Rework the PSC connection to support SSL and be available globally ([#199](https://github.com/wandb/terraform-google-wandb/issues/199)) ([edd460b](https://github.com/wandb/terraform-google-wandb/commit/edd460b66ea11d27a11fdd70bf1e00d35214c461))

### [7.0.2](https://github.com/wandb/terraform-google-wandb/compare/v7.0.1...v7.0.2) (2025-01-08)


### Bug Fixes

* Pass identity to console ([#203](https://github.com/wandb/terraform-google-wandb/issues/203)) ([4f74d30](https://github.com/wandb/terraform-google-wandb/commit/4f74d30680519e40f43e85d06c8abd3c4564c8e7))

### [7.0.1](https://github.com/wandb/terraform-google-wandb/compare/v7.0.0...v7.0.1) (2025-01-07)


### Bug Fixes

* missing var passthrough ([#202](https://github.com/wandb/terraform-google-wandb/issues/202)) ([327a97c](https://github.com/wandb/terraform-google-wandb/commit/327a97cfdf53d38ccd12f7ac139ebd44a679bd53))

## [7.0.0](https://github.com/wandb/terraform-google-wandb/compare/v6.6.1...v7.0.0) (2025-01-06)


### ⚠ BREAKING CHANGES

* Bump helm-wandb vers to v2.0.0, requires TF > 1.9 (#200)

### Features

* Bump helm-wandb vers to v2.0.0, requires TF > 1.9 ([#200](https://github.com/wandb/terraform-google-wandb/issues/200)) ([3b3e811](https://github.com/wandb/terraform-google-wandb/commit/3b3e81122661681ed80a1cedfd531351f0469bfd))

### [6.6.1](https://github.com/wandb/terraform-google-wandb/compare/v6.6.0...v6.6.1) (2025-01-03)


### Bug Fixes

* Tune mysql database flags ([#187](https://github.com/wandb/terraform-google-wandb/issues/187)) ([f7c5659](https://github.com/wandb/terraform-google-wandb/commit/f7c5659a2b0fdc70208b1297d37c0e3d37691eda))

## [6.6.0](https://github.com/wandb/terraform-google-wandb/compare/v6.5.2...v6.6.0) (2024-12-18)


### Features

* Enable GCS FUSE driver addon ([#198](https://github.com/wandb/terraform-google-wandb/issues/198)) ([510164a](https://github.com/wandb/terraform-google-wandb/commit/510164a79c39655ac5276861d1ac797a9d75c220))

### [6.5.2](https://github.com/wandb/terraform-google-wandb/compare/v6.5.1...v6.5.2) (2024-12-12)


### Bug Fixes

* Ignore lifecycle of the locations for redis ([#195](https://github.com/wandb/terraform-google-wandb/issues/195)) ([d28ecce](https://github.com/wandb/terraform-google-wandb/commit/d28ecce6d0a3dc44e7c6545a8cf26a0d3e208765))

### [6.5.1](https://github.com/wandb/terraform-google-wandb/compare/v6.5.0...v6.5.1) (2024-12-12)


### Bug Fixes

* don't make the entire cluster private, just the nodes ([#194](https://github.com/wandb/terraform-google-wandb/issues/194)) ([98c6d09](https://github.com/wandb/terraform-google-wandb/commit/98c6d090f2ab6d6e55c8a45f41e6ddca14e62341))

## [6.5.0](https://github.com/wandb/terraform-google-wandb/compare/v6.4.0...v6.5.0) (2024-12-12)


### Features

* Added support gke private node ([#190](https://github.com/wandb/terraform-google-wandb/issues/190)) ([eb2280a](https://github.com/wandb/terraform-google-wandb/commit/eb2280aa2633de082ddaa2ea9c4ca89781f9e1dd))

## [6.4.0](https://github.com/wandb/terraform-google-wandb/compare/v6.3.0...v6.4.0) (2024-12-12)


### Features

* Add additional label references ([#193](https://github.com/wandb/terraform-google-wandb/issues/193)) ([227f60b](https://github.com/wandb/terraform-google-wandb/commit/227f60b93fb32215d57f01426ca29600fd56f27b))

## [6.3.0](https://github.com/wandb/terraform-google-wandb/compare/v6.2.1...v6.3.0) (2024-12-02)


### Features

* Add internalJWTMap variables used for inter service request authentication ([#177](https://github.com/wandb/terraform-google-wandb/issues/177)) ([69732e0](https://github.com/wandb/terraform-google-wandb/commit/69732e0a5e78946712391c1e625c69ffc11d0d21))


### Bug Fixes

* Binlog_row_image needs to have lowercase value ([#182](https://github.com/wandb/terraform-google-wandb/issues/182)) ([ce99cb0](https://github.com/wandb/terraform-google-wandb/commit/ce99cb0691539a514ed96b846a8e98c8ce522d10))

### [6.2.1](https://github.com/wandb/terraform-google-wandb/compare/v6.2.0...v6.2.1) (2024-12-02)


### Bug Fixes

* Fix database instance flag ([#183](https://github.com/wandb/terraform-google-wandb/issues/183)) ([a9329dd](https://github.com/wandb/terraform-google-wandb/commit/a9329ddf24de5c3d8fd1fe77264e150595902f5f))

## [6.2.0](https://github.com/wandb/terraform-google-wandb/compare/v6.1.0...v6.2.0) (2024-11-27)


### Features

* Configure notify-keyspace-events for redis ([#180](https://github.com/wandb/terraform-google-wandb/issues/180)) ([e63e89f](https://github.com/wandb/terraform-google-wandb/commit/e63e89fe26fc935ccbda2e2a2ae13fb4b63865f6))

## [6.1.0](https://github.com/wandb/terraform-google-wandb/compare/v6.0.0...v6.1.0) (2024-11-27)


### Features

* Additional database flags and refactor to allow new flags to be passed via map ([#181](https://github.com/wandb/terraform-google-wandb/issues/181)) ([68ed4d2](https://github.com/wandb/terraform-google-wandb/commit/68ed4d26525cb8b4b03321967d2b18d560a566f8))


### Bug Fixes

* Improve BYOB config ([#174](https://github.com/wandb/terraform-google-wandb/issues/174)) ([bec5e9f](https://github.com/wandb/terraform-google-wandb/commit/bec5e9f0d136e87355447eb36c2c82f76fb139e6))

## [6.0.0](https://github.com/wandb/terraform-google-wandb/compare/v5.4.2...v6.0.0) (2024-10-08)


### ⚠ BREAKING CHANGES

* A number of variable defaults are removed and variables renamed for node counts.

### Features

* Enable autoscaling ([#169](https://github.com/wandb/terraform-google-wandb/issues/169)) ([faebff7](https://github.com/wandb/terraform-google-wandb/commit/faebff781006aa39b816006fed2bd19a94351fd3))

### [5.4.2](https://github.com/wandb/terraform-google-wandb/compare/v5.4.1...v5.4.2) (2024-10-01)


### Bug Fixes

* Use variables for operator helm release ([#173](https://github.com/wandb/terraform-google-wandb/issues/173)) ([0964e71](https://github.com/wandb/terraform-google-wandb/commit/0964e7133786cfdfc863bca6e04c607da0b5e782))

### [5.4.1](https://github.com/wandb/terraform-google-wandb/compare/v5.4.0...v5.4.1) (2024-09-16)


### Bug Fixes

* Allow skipping the modification of the bucket to add our service account's permissions ([#171](https://github.com/wandb/terraform-google-wandb/issues/171)) ([7c949be](https://github.com/wandb/terraform-google-wandb/commit/7c949bee52388b338e837f80a7ca9584fb5105ed))

## [5.4.0](https://github.com/wandb/terraform-google-wandb/compare/v5.3.4...v5.4.0) (2024-09-12)


### Features

* Add support for Private Service Connect to ClickHouse ([#168](https://github.com/wandb/terraform-google-wandb/issues/168)) ([62dbc62](https://github.com/wandb/terraform-google-wandb/commit/62dbc629c875dc3bebcce5efefb4834379fa4f71))

### [5.3.4](https://github.com/wandb/terraform-google-wandb/compare/v5.3.3...v5.3.4) (2024-09-12)


### Bug Fixes

* Bump operator chart and controller image ([#170](https://github.com/wandb/terraform-google-wandb/issues/170)) ([37c8774](https://github.com/wandb/terraform-google-wandb/commit/37c8774caf7db083a1d48eea78542dde2637b4a3))

### [5.3.3](https://github.com/wandb/terraform-google-wandb/compare/v5.3.2...v5.3.3) (2024-09-04)


### Bug Fixes

* Name Typo ([#164](https://github.com/wandb/terraform-google-wandb/issues/164)) ([6ac348b](https://github.com/wandb/terraform-google-wandb/commit/6ac348b83569f94b54b2a9ef6aadbe30e1bd9882))

### [5.3.2](https://github.com/wandb/terraform-google-wandb/compare/v5.3.1...v5.3.2) (2024-08-29)


### Bug Fixes

* Cleanup unneeded otel configs ([#162](https://github.com/wandb/terraform-google-wandb/issues/162)) ([38e63b1](https://github.com/wandb/terraform-google-wandb/commit/38e63b17fd91eff4bbf6a40c0cec724fbaa6b7cc))

### [5.3.1](https://github.com/wandb/terraform-google-wandb/compare/v5.3.0...v5.3.1) (2024-08-26)


### Bug Fixes

* Fix redis port ([#161](https://github.com/wandb/terraform-google-wandb/issues/161)) ([6647636](https://github.com/wandb/terraform-google-wandb/commit/66476360f2c97528dfe37f0c1ec2765bbb7c6f52))

## [5.3.0](https://github.com/wandb/terraform-google-wandb/compare/v5.2.2...v5.3.0) (2024-08-23)


### Features

* Add optional path var for instance level bucket path ([#145](https://github.com/wandb/terraform-google-wandb/issues/145)) ([e95bc6a](https://github.com/wandb/terraform-google-wandb/commit/e95bc6ab276152af2419fadb335af23b91e9c0ca))

### [5.2.2](https://github.com/wandb/terraform-google-wandb/compare/v5.2.1...v5.2.2) (2024-08-01)


### Bug Fixes

* Bump operator chart versions ([#158](https://github.com/wandb/terraform-google-wandb/issues/158)) ([0264e1f](https://github.com/wandb/terraform-google-wandb/commit/0264e1fb368974e9c26756b9f29a430273cebeb9))

### [5.2.1](https://github.com/wandb/terraform-google-wandb/compare/v5.2.0...v5.2.1) (2024-08-01)


### Bug Fixes

* Bump operator chart versions ([#157](https://github.com/wandb/terraform-google-wandb/issues/157)) ([88ad566](https://github.com/wandb/terraform-google-wandb/commit/88ad566d76002df9936f4c74032236156f25196e))

## [5.2.0](https://github.com/wandb/terraform-google-wandb/compare/v5.1.3...v5.2.0) (2024-07-31)


### Features

* Bump operator image and chart versions ([#156](https://github.com/wandb/terraform-google-wandb/issues/156)) ([dd83f51](https://github.com/wandb/terraform-google-wandb/commit/dd83f51368f7b7d99fa4d59d86f0483eb365a314))

### [5.1.3](https://github.com/wandb/terraform-google-wandb/compare/v5.1.2...v5.1.3) (2024-07-25)


### Bug Fixes

* Typo on SA Member ([#155](https://github.com/wandb/terraform-google-wandb/issues/155)) ([2262da2](https://github.com/wandb/terraform-google-wandb/commit/2262da2f1a36647194c9f8292814798f15cb33a1))

### [5.1.2](https://github.com/wandb/terraform-google-wandb/compare/v5.1.1...v5.1.2) (2024-07-23)


### Bug Fixes

* Correct Encryption Logic ([#154](https://github.com/wandb/terraform-google-wandb/issues/154)) ([e68805c](https://github.com/wandb/terraform-google-wandb/commit/e68805c0eb7115f3ff13a42d80fdefa0d966024c))

### [5.1.1](https://github.com/wandb/terraform-google-wandb/compare/v5.1.0...v5.1.1) (2024-07-23)


### Bug Fixes

* Tier typo/mistake ([#153](https://github.com/wandb/terraform-google-wandb/issues/153)) ([5d632e4](https://github.com/wandb/terraform-google-wandb/commit/5d632e4408d91674f1ff33ebae49e6b583e91d72))

## [5.1.0](https://github.com/wandb/terraform-google-wandb/compare/v5.0.1...v5.1.0) (2024-07-23)


### Features

* Added support for encrypting the database and bucket with CMK ([#100](https://github.com/wandb/terraform-google-wandb/issues/100)) ([7802e3c](https://github.com/wandb/terraform-google-wandb/commit/7802e3ce1f227f3e641d2e1bdb6c01db4de5cac9))

### [5.0.1](https://github.com/wandb/terraform-google-wandb/compare/v5.0.0...v5.0.1) (2024-07-22)


### Bug Fixes

* Weave SA ([#152](https://github.com/wandb/terraform-google-wandb/issues/152)) ([81aca11](https://github.com/wandb/terraform-google-wandb/commit/81aca117e939d93cc4769ae3106fda706cb62f60))

## [5.0.0](https://github.com/wandb/terraform-google-wandb/compare/v4.0.3...v5.0.0) (2024-07-18)


### ⚠ BREAKING CHANGES

* Service Account Mapping (#151)

### Features

* Service Account Mapping ([#151](https://github.com/wandb/terraform-google-wandb/issues/151)) ([8930eaf](https://github.com/wandb/terraform-google-wandb/commit/8930eafde09a7013d57e2dec045685765d2d84c4))

### [4.0.3](https://github.com/wandb/terraform-google-wandb/compare/v4.0.2...v4.0.3) (2024-07-18)


### Bug Fixes

* Kms sa name ([#150](https://github.com/wandb/terraform-google-wandb/issues/150)) ([1a70cdf](https://github.com/wandb/terraform-google-wandb/commit/1a70cdff42ef3b35386386b674af5643e23fbd00))

### [4.0.2](https://github.com/wandb/terraform-google-wandb/compare/v4.0.1...v4.0.2) (2024-07-17)


### Bug Fixes

* Stackdriver SA name ([#148](https://github.com/wandb/terraform-google-wandb/issues/148)) ([e67c9fc](https://github.com/wandb/terraform-google-wandb/commit/e67c9fc5a09459893ebc7960e9c40a315cc9e6f3))

### [4.0.1](https://github.com/wandb/terraform-google-wandb/compare/v4.0.0...v4.0.1) (2024-07-16)


### Bug Fixes

* Stackdriver SA regex ([#147](https://github.com/wandb/terraform-google-wandb/issues/147)) ([aa9dfc5](https://github.com/wandb/terraform-google-wandb/commit/aa9dfc52c95f8355e216f4dab5b3f428d17931cf))

## [4.0.0](https://github.com/wandb/terraform-google-wandb/compare/v3.7.0...v4.0.0) (2024-07-15)


### ⚠ BREAKING CHANGES

* Index error and missing breaking change (#146)

### Bug Fixes

* Index error and missing breaking change ([#146](https://github.com/wandb/terraform-google-wandb/issues/146)) ([3e2c484](https://github.com/wandb/terraform-google-wandb/commit/3e2c48477117cb39687e68d08d5b06c7d595cbde))

## [3.7.0](https://github.com/wandb/terraform-google-wandb/compare/v3.6.1...v3.7.0) (2024-07-15)


### Features

* Added namespace as a prefix in stackdriver sa name ([#144](https://github.com/wandb/terraform-google-wandb/issues/144)) ([af49f8b](https://github.com/wandb/terraform-google-wandb/commit/af49f8b2afe67f14d0b9f4648a7133985cc4626d))

### [3.6.1](https://github.com/wandb/terraform-google-wandb/compare/v3.6.0...v3.6.1) (2024-07-11)


### Bug Fixes

* Pass cloudprovider value to the helm charts ([#143](https://github.com/wandb/terraform-google-wandb/issues/143)) ([3037416](https://github.com/wandb/terraform-google-wandb/commit/3037416ec24dff0f55223383be9dc7dd380248a8))

## [3.6.0](https://github.com/wandb/terraform-google-wandb/compare/v3.5.0...v3.6.0) (2024-07-04)


### Features

* Added support for GCP Private Service Connect ([#115](https://github.com/wandb/terraform-google-wandb/issues/115)) ([4c47c0a](https://github.com/wandb/terraform-google-wandb/commit/4c47c0aa41cd3f3b9392dd2a84dc3d583bb096c8))

## [3.5.0](https://github.com/wandb/terraform-google-wandb/compare/v3.4.0...v3.5.0) (2024-06-21)


### Features

* Added examples ([#123](https://github.com/wandb/terraform-google-wandb/issues/123)) ([083d6cc](https://github.com/wandb/terraform-google-wandb/commit/083d6cce70306359727648b83ff5189b2b69a9cc))

## [3.4.0](https://github.com/wandb/terraform-google-wandb/compare/v3.3.0...v3.4.0) (2024-06-21)


### Features

* Added t-shirt size support ([#135](https://github.com/wandb/terraform-google-wandb/issues/135)) ([f8a3a2f](https://github.com/wandb/terraform-google-wandb/commit/f8a3a2fa8bf95f594dc9525ce568097abbb0dd42))

## [3.3.0](https://github.com/wandb/terraform-google-wandb/compare/v3.2.0...v3.3.0) (2024-06-18)


### Features

* Added service account name in stackdriver conf ([#136](https://github.com/wandb/terraform-google-wandb/issues/136)) ([87aa2b9](https://github.com/wandb/terraform-google-wandb/commit/87aa2b9a6f59aa9364f17b2087fde8df6a51acbe)), closes [#113](https://github.com/wandb/terraform-google-wandb/issues/113)

## [3.2.0](https://github.com/wandb/terraform-google-wandb/compare/v3.1.1...v3.2.0) (2024-06-07)


### Features

* Track the otel and stackdriver sa issue ([#134](https://github.com/wandb/terraform-google-wandb/issues/134)) ([08abe84](https://github.com/wandb/terraform-google-wandb/commit/08abe848938ba80d48c2e747b5e9f229dd01eda4))

### [3.1.1](https://github.com/wandb/terraform-google-wandb/compare/v3.1.0...v3.1.1) (2024-06-05)


### Bug Fixes

* Consistent object type for redis ([#133](https://github.com/wandb/terraform-google-wandb/issues/133)) ([34c5d94](https://github.com/wandb/terraform-google-wandb/commit/34c5d94da5ba75d9d5c7ad6ebbd6aef66bf702c4))

## [3.1.0](https://github.com/wandb/terraform-google-wandb/compare/v3.0.5...v3.1.0) (2024-06-05)


### Features

* added support for stackdriver and otel metrics ([#126](https://github.com/wandb/terraform-google-wandb/issues/126)) ([1e8777a](https://github.com/wandb/terraform-google-wandb/commit/1e8777af0f6bf6e8260a0faa488302f631b716b3))

### [3.0.5](https://github.com/wandb/terraform-google-wandb/compare/v3.0.4...v3.0.5) (2024-06-05)


### Bug Fixes

* Need the global redis helm values to not be null even when disabled ([#131](https://github.com/wandb/terraform-google-wandb/issues/131)) ([e8c4602](https://github.com/wandb/terraform-google-wandb/commit/e8c46022cbb5d9ca76f62ad14bded42279e5dfb6))

### [3.0.4](https://github.com/wandb/terraform-google-wandb/compare/v3.0.3...v3.0.4) (2024-04-12)


### Bug Fixes

* Pass through env vars for services ([#117](https://github.com/wandb/terraform-google-wandb/issues/117)) ([35e15c0](https://github.com/wandb/terraform-google-wandb/commit/35e15c096372e549656877137c08529e2b32bcec))

### [3.0.3](https://github.com/wandb/terraform-google-wandb/compare/v3.0.2...v3.0.3) (2024-04-10)


### Bug Fixes

* Remove passthrough vars for old module ([#119](https://github.com/wandb/terraform-google-wandb/issues/119)) ([5b61465](https://github.com/wandb/terraform-google-wandb/commit/5b614651a50562e82a7506b76b0fece2035bf68c))

### [3.0.2](https://github.com/wandb/terraform-google-wandb/compare/v3.0.1...v3.0.2) (2024-04-10)


### Bug Fixes

* Conditionally set oidc envs ([#118](https://github.com/wandb/terraform-google-wandb/issues/118)) ([0df0ec8](https://github.com/wandb/terraform-google-wandb/commit/0df0ec8fb47fb18bf8cd4d6f8dc108f3e2ee5458))

### [3.0.1](https://github.com/wandb/terraform-google-wandb/compare/v3.0.0...v3.0.1) (2024-03-22)


### Bug Fixes

* **dev:** Add passthrough for env vars ([#112](https://github.com/wandb/terraform-google-wandb/issues/112)) ([02278b0](https://github.com/wandb/terraform-google-wandb/commit/02278b0772337dbad615be13a67caf96d67ac2b3))

## [3.0.0](https://github.com/wandb/terraform-google-wandb/compare/v2.0.1...v3.0.0) (2024-03-15)


### ⚠ BREAKING CHANGES

* Enable operator as default (#114)

### Features

* Enable operator as default ([#114](https://github.com/wandb/terraform-google-wandb/issues/114)) ([10b501b](https://github.com/wandb/terraform-google-wandb/commit/10b501b6fb77c4ee8def6d5a7a1cdc86fd97afb8))

### [2.0.1](https://github.com/wandb/terraform-google-wandb/compare/v2.0.0...v2.0.1) (2024-03-06)


### Bug Fixes

* Bump controller image and readd chart version ([#108](https://github.com/wandb/terraform-google-wandb/issues/108)) ([92a9bb4](https://github.com/wandb/terraform-google-wandb/commit/92a9bb4e991556bc4ecb86d4d588f115452ba3c9))

## [2.0.0](https://github.com/wandb/terraform-google-wandb/compare/v1.24.2...v2.0.0) (2024-03-06)


### ⚠ BREAKING CHANGES

* Bump operator chart version (#105)

### Features

* Bump operator chart version ([#105](https://github.com/wandb/terraform-google-wandb/issues/105)) ([3fde6be](https://github.com/wandb/terraform-google-wandb/commit/3fde6be607a0e7728ffb0949e836e00573d78a6c))

### [1.24.2](https://github.com/wandb/terraform-google-wandb/compare/v1.24.1...v1.24.2) (2024-03-06)


### Bug Fixes

* Add ingress name ([#107](https://github.com/wandb/terraform-google-wandb/issues/107)) ([e659c40](https://github.com/wandb/terraform-google-wandb/commit/e659c4085ec96e9fa2605e2729e54d3127d8ad53))

### [1.24.1](https://github.com/wandb/terraform-google-wandb/compare/v1.24.0...v1.24.1) (2024-03-05)


### Bug Fixes

* Add oidc secret ([#106](https://github.com/wandb/terraform-google-wandb/issues/106)) ([19cdd25](https://github.com/wandb/terraform-google-wandb/commit/19cdd250aee1826ab7a34b96627e80b5f5eb5ee3))

## [1.24.0](https://github.com/wandb/terraform-google-wandb/compare/v1.23.3...v1.24.0) (2024-03-04)


### Features

* Add operator helm release ([#98](https://github.com/wandb/terraform-google-wandb/issues/98)) ([e3916a7](https://github.com/wandb/terraform-google-wandb/commit/e3916a76b47ea2afc2cc5b3dfae8b0e0bffd5dd7)), closes [#92](https://github.com/wandb/terraform-google-wandb/issues/92) [#101](https://github.com/wandb/terraform-google-wandb/issues/101) [#101](https://github.com/wandb/terraform-google-wandb/issues/101) [#102](https://github.com/wandb/terraform-google-wandb/issues/102)

### [1.23.3](https://github.com/wandb/terraform-google-wandb/compare/v1.23.2...v1.23.3) (2024-03-01)


### Bug Fixes

* Fix Redis Tier ([#103](https://github.com/wandb/terraform-google-wandb/issues/103)) ([432517e](https://github.com/wandb/terraform-google-wandb/commit/432517ef30460f6c0bf63e0b117f6f3db9347540))

### [1.23.2](https://github.com/wandb/terraform-google-wandb/compare/v1.23.1...v1.23.2) (2024-02-22)


### Bug Fixes

* Backwards compatibility fix to avoid changes in nodegroups. ([#102](https://github.com/wandb/terraform-google-wandb/issues/102)) ([c331853](https://github.com/wandb/terraform-google-wandb/commit/c3318536187b9cd17d9371c64b602e3aa8f5c399))

### [1.23.1](https://github.com/wandb/terraform-google-wandb/compare/v1.23.0...v1.23.1) (2024-02-21)


### Bug Fixes

* Backwards compatibility for t-shirt-sized deployments ([#101](https://github.com/wandb/terraform-google-wandb/issues/101)) ([f812f81](https://github.com/wandb/terraform-google-wandb/commit/f812f810ec6addd3f8a18fe114d320245d64c9da))

## [1.23.0](https://github.com/wandb/terraform-google-wandb/compare/v1.22.0...v1.23.0) (2024-02-21)


### Features

* Add support for t-shirt-sized deployments ([#91](https://github.com/wandb/terraform-google-wandb/issues/91)) ([5432961](https://github.com/wandb/terraform-google-wandb/commit/5432961f6688a5eed5a646d7ab772f28844d4bf7)), closes [#92](https://github.com/wandb/terraform-google-wandb/issues/92)

## [1.22.0](https://github.com/wandb/terraform-google-wandb/compare/v1.21.0...v1.22.0) (2023-12-15)


### Features

* Update redis reserved ip range and Add deletion protection to database ([#92](https://github.com/wandb/terraform-google-wandb/issues/92)) ([c5ec027](https://github.com/wandb/terraform-google-wandb/commit/c5ec02738cb4a047c44e8e8b14cb85c0c9620034))

## [1.21.0](https://github.com/wandb/terraform-google-wandb/compare/v1.20.2...v1.21.0) (2023-10-27)


### Features

* Add support for Google Secret Manager ([#89](https://github.com/wandb/terraform-google-wandb/issues/89)) ([8eb6b98](https://github.com/wandb/terraform-google-wandb/commit/8eb6b98e29d491deb5f3ff9d6735ff14d89b61a9))

### [1.20.2](https://github.com/wandb/terraform-google-wandb/compare/v1.20.1...v1.20.2) (2023-10-27)


### Bug Fixes

* Remove unused var from BYBO example ([#90](https://github.com/wandb/terraform-google-wandb/issues/90)) ([8377c01](https://github.com/wandb/terraform-google-wandb/commit/8377c01c1fa98656972b81004827a68d6b3778b9))

### [1.20.1](https://github.com/wandb/terraform-google-wandb/compare/v1.20.0...v1.20.1) (2023-10-09)


### Bug Fixes

* Enable additional GKE outputs ([#88](https://github.com/wandb/terraform-google-wandb/issues/88)) ([6799afd](https://github.com/wandb/terraform-google-wandb/commit/6799afdbc0eecf262cbbaae58faaa3a4390aa1fb))

## [1.20.0](https://github.com/wandb/terraform-google-wandb/compare/v1.19.2...v1.20.0) (2023-10-06)


### Features

* Update terraform-wandb-kubernetes ([#87](https://github.com/wandb/terraform-google-wandb/issues/87)) ([55bcdc6](https://github.com/wandb/terraform-google-wandb/commit/55bcdc6b0aabb7f5c0739833a1040bf5e9e22103))

### [1.19.2](https://github.com/wandb/terraform-google-wandb/compare/v1.19.1...v1.19.2) (2023-10-05)


### Bug Fixes

* Fix ssl certificate recreation ([#86](https://github.com/wandb/terraform-google-wandb/issues/86)) ([8d0e800](https://github.com/wandb/terraform-google-wandb/commit/8d0e80007de2064e85a2e78730243f54a1ead0e4))

### [1.19.1](https://github.com/wandb/terraform-google-wandb/compare/v1.19.0...v1.19.1) (2023-10-05)


### Bug Fixes

* Amend resource requests and limits ([#85](https://github.com/wandb/terraform-google-wandb/issues/85)) ([c0aed88](https://github.com/wandb/terraform-google-wandb/commit/c0aed881b361e2ad24461aa7d90665213d85028b))

## [1.19.0](https://github.com/wandb/terraform-google-wandb/compare/v1.18.0...v1.19.0) (2023-09-29)


### Features

* Add Google Container Cluster Name to outputs ([#84](https://github.com/wandb/terraform-google-wandb/issues/84)) ([9c56aa3](https://github.com/wandb/terraform-google-wandb/commit/9c56aa30cb2906744d19dd90e70218c9ca960005))

## [1.18.0](https://github.com/wandb/terraform-google-wandb/compare/v1.17.0...v1.18.0) (2023-09-18)


### Features

* Update google provider ([#83](https://github.com/wandb/terraform-google-wandb/issues/83)) ([30d4243](https://github.com/wandb/terraform-google-wandb/commit/30d4243eb31c4b04ad295d5e63868b980228bd8e))

## [1.17.0](https://github.com/wandb/terraform-google-wandb/compare/v1.16.0...v1.17.0) (2023-09-13)


### Features

* Amend resource limits ([#81](https://github.com/wandb/terraform-google-wandb/issues/81)) ([074bd67](https://github.com/wandb/terraform-google-wandb/commit/074bd67f5f19cace81eac4f00847170e14c3a862))
* Update to terraform-kubernetes-wandb v1.12.0 ([#80](https://github.com/wandb/terraform-google-wandb/issues/80)) ([056f53a](https://github.com/wandb/terraform-google-wandb/commit/056f53aca46956acf0e774ba689127a43eef8dee))

## [1.16.0](https://github.com/wandb/terraform-google-wandb/compare/v1.15.0...v1.16.0) (2023-09-12)


### Features

* Upgrade k8s provider v2.23.0 ([#79](https://github.com/wandb/terraform-google-wandb/issues/79)) ([1e0ecd9](https://github.com/wandb/terraform-google-wandb/commit/1e0ecd93ace5eacffeeff22994ec556a52854046))

## [1.15.0](https://github.com/wandb/terraform-google-wandb/compare/v1.14.3...v1.15.0) (2023-09-07)


### Features

* Require inbound cidrs be set explicitly ([#78](https://github.com/wandb/terraform-google-wandb/issues/78)) ([9ee945e](https://github.com/wandb/terraform-google-wandb/commit/9ee945e4f29ff1267c0b995c3b2c68bfc8cce717))

### [1.14.3](https://github.com/wandb/terraform-google-wandb/compare/v1.14.2...v1.14.3) (2023-09-04)


### Bug Fixes

* Bump pod resources according GKE node size ([#77](https://github.com/wandb/terraform-google-wandb/issues/77)) ([19821b5](https://github.com/wandb/terraform-google-wandb/commit/19821b59a09c9c870f71470da8cb0fca6e5c59b4))

### [1.14.2](https://github.com/wandb/terraform-google-wandb/compare/v1.14.1...v1.14.2) (2023-08-10)


### Bug Fixes

* Create LICENSE ([#71](https://github.com/wandb/terraform-google-wandb/issues/71)) ([fa125dc](https://github.com/wandb/terraform-google-wandb/commit/fa125dce2536e804a0125563160f52e749044157))

### [1.14.1](https://github.com/wandb/terraform-google-wandb/compare/v1.14.0...v1.14.1) (2023-04-10)


### Bug Fixes

* Update readme ([#67](https://github.com/wandb/terraform-google-wandb/issues/67)) ([6d03fbb](https://github.com/wandb/terraform-google-wandb/commit/6d03fbb47022f94cd0f61a3a5776ba1a6e338e7e))

## [1.14.0](https://github.com/wandb/terraform-google-wandb/compare/v1.13.5...v1.14.0) (2023-04-06)


### Features

* Add SSL policy to LB ([#65](https://github.com/wandb/terraform-google-wandb/issues/65)) ([a4251b2](https://github.com/wandb/terraform-google-wandb/commit/a4251b2b39216df7404640dddb89df08f912bd2b))

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
