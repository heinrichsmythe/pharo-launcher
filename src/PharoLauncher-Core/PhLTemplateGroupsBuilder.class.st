"
I'm in charge of building the list of templates groups and its associated templates from a list of template sources.

I use as input an instance of PhLTemplateSources.
The default input is the serialized ston file 'sources.list' defining templates sources (stored in Launcher directory).
I'm used at Launcher creation, see PharoLauncher>>#createLauncher.

To update the liste of sources, please update the sources files hosted at http://files.pharo.org/pharo-launcher/sources.list
"
Class {
	#name : #PhLTemplateGroupsBuilder,
	#superclass : #Object,
	#instVars : [
		'sources',
		'groups',
		'templates'
	],
	#category : #'PharoLauncher-Core-Model'
}

{ #category : #'instance creation' }
PhLTemplateGroupsBuilder class >> build [
	^ self buildFrom: PhLTemplateSources fromFile
]

{ #category : #'instance creation' }
PhLTemplateGroupsBuilder class >> buildFrom: aPhLTemplateSources [
	^ self new 
		initializeWithSources: aPhLTemplateSources;
		build
]

{ #category : #'instance creation' }
PhLTemplateGroupsBuilder class >> buildFromSourceList: aListOfPhLTemplateSource [
	| file |
	file := FileSystem memory / 'sources.list'.
file writeStreamDo: [ :stream | | stonString |
		stonString := STON 
			put: aListOfPhLTemplateSource
			onStreamPretty: stream.
		stream nextPutAll: stonString ].
	^ self new 
		initializeWithSources: (PhLTemplateSources withFile: file);
		build
]

{ #category : #building }
PhLTemplateGroupsBuilder >> build [
	sources ensureSourcesFile.
	^ groups := sources
		collect: [ :source | 
			| group |
			group := source asTemplateGroup.
			source templatesDo: [ :templateSource | group addTemplate: templateSource asTemplate ].
			group ]
]

{ #category : #initialization }
PhLTemplateGroupsBuilder >> initializeWithSources: aListOfTemplateSource [ 
	sources := aListOfTemplateSource.
	groups := OrderedCollection new.
]
