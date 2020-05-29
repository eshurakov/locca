# Locca 
Locca is a command line tool that helps with localisation of iOS (and a bit for Android) projects.

**It can:**
 
* Scan source code and update language files
* Synchronise language files with OneSky localisation platform
* Find missing / extra / not translated keys in language files

**Difference from `genstrings`**  
While updating language files `locca` doesn't modify already translated keys. It adds new keys and remove keys, that are no longer present in source code.

## Installation

`gem install locca`

## Configuration
Put `.locca/config` file in the root of your project. Locca can be run from any folder within the project.

**iOS**

```
{
	"project_file": “App.xcodeproj",
	"base_lang": "en",
	"prevent_sync_without_comments": false,

	"targets": {
		"App": {
			"audit_ignore": ["key1", "key2"]
			"onesky_project_id": "12345",
			"onesky_public_key": "abcd",
			"onesky_secret_key": "dcba"
		},
		"App-Watch": {
			"audit_ignore": ["key1", "key2"]
			"onesky_project_id": "54321",
			"onesky_public_key": "abcd",
			"onesky_secret_key": "dcba"
		},
	}
}
```

**Android**

```
{
	"base_lang": "en",
	"lang_dir": "",
	"prevent_sync_without_comments": false,

	"onesky_project_id": "12345",
	"onesky_public_key": "abcd",
	"onesky_secret_key": "dcba"

	"audit_ignore": ["key1", "key2"]
}
```

## Available commands

### Build
`locca build`

on iOS: scans source files in one or more application targets and merges found strings with language files.

on Android: sorts keys in language files alphabetically.

### Fetch
`locca fetch` fetches and merges keys from external translation service (OneSky) with local language files.

### Sync
`locca sync` fetches first and then uploads local language files to external translation service.

### Audit
`locca audit` checks language files for missing / extra / not translated keys.

### Translate
`locca translate` finds all not translated keys and opens them in an editor (using `EDITOR` env variable). After saving editor content keys are merged back with language files.
