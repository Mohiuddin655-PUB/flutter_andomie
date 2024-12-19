## 0.5.67

* Add LazyNotifier to handler ui changes from outside

## 0.5.66

* Add total, maximum, minimum operations in IterableNumExtension
* Add asMinPoint and asMaxPoint operations in NumExtension

## 0.5.65

* Add sequence iterable operation

## 0.5.64

* Add cache function for CacheManager

## 0.5.63+1

## 0.5.63

* Rename DateConverter to DateHelper
* Add weekday to date

## 0.5.62

* Add AndomieIcon to make any icon as three states like [regular, solid, bold]
* Convert AssetIcon as AndomieIcon

## 0.5.61

* Rename CacheManager caller function request to cache

## 0.5.60

* Renamed DataKeeper to CacheManager

## 0.5.59

* Add isLookup, lookup, text, sub, sum, mul, div, etc operations in iterable extension
* Add list and cleanedText operations in string extension

## 0.5.58+1

* Add isSame operation in iterable extension

## 0.5.58

* Add random picker in iterable extension

## 0.5.57

* Add TextParser util to parse any text to spannable texts

## 0.5.56

* Add RapidClick util to handle multi-click and apply last click with counter value

## 0.5.55

* Add loading property inside the Selector model to apply loading mechanism in ui easily

## 0.5.54

* Add Isolation util to use multi-call future data

## 0.5.53

* Convert update for [asString, asList]

## 0.5.52

* Add firstWhereOrNull, lastWhereOrNull, and mergeByTags iterable extensions

## 0.5.51

* Add locales util

## 0.5.50

* Change findByKey, getByKey, findsByKey, and getsByKey params structures
* Renamed OrderedListSequence to OrderedListStyle and implement from factory method with extension

## 0.5.49

* Add OrderedListSequence util to counting list index as sequence like a, b, c, ..., aa, ab, ac, ...

## 0.5.48

* Update converter
* Add assets loader util

## 0.5.47

* Selection update function renamed [update to copy]

## 0.5.46

* Add selection model to use selectable option
* Add list finder operation for [change]

## 0.5.45

* Add DataKeeper util to maintain api request only one if data is similar and provide data from
  local data of DataKeeper

## 0.5.44

## 0.5.43

* Add findIndexes from iterable

## 0.5.42

* Improve all object finder operations

## 0.5.41

* Rename PathFinder to PathParser and add three fields in PathInfo [source, collections, documents]

## 0.5.40

* Modify KeyGenerator [uniqueKey, dateKey, generateKey, haxKey, secretKey]

## 0.5.39

* Remove intl and other libraries
* Add instance mode to use third-party library from real app
* Modify replacement utils for all none chars to custom chars

## 0.5.38

* Update SwipeLockProvider [onSwiped, onLocked, limit, count, lockoutRemainder]

## 0.5.37

* Add object finder operations [get, getByKey, getOrNull]

## 0.5.36

* Add object finder operations [find, findByKey, findOrNull]
* Remove object finder operation [get] and replace [findOrNull]

## 0.5.35

* Number text format: PlusText [-50.toPlusText("+") to +50]
* Number text format: PercentageText [0.5.toPercentageText("%") to 50%]

## 0.5.34

* Number validation using operation and remove math library

## 0.5.33

* Number validation using math library

## 0.5.32

* Add [BMICalculator]
* Add [auto add or remove number fractionDigits]
* Add converter [string to num value]

## 0.5.31

* Model
    - Selector

## 0.5.30

## 0.5.29

* Extension
    - Spacing

## 0.5.28

* PROVIDER
    - check color brightness
    - check image brightness

## 0.5.27

* SWIPE_LOCK_PROVIDER
    - Initial remaining time bug fixed

## 0.5.26

* IndexProvider
    - Pick index from length by sequence
    - Pick index as reverse from length by sequence
    - Pick T item from length by sequence
    - Pick T item as reverse from length by sequence

* ColorGenerator
    - Pick color system from existing colors by sequence

## 0.5.25

* ColorGenerator
    - Pick color system from existing colors by sequence or index

## 0.5.24

* SWIPE_LOCK_PROVIDER
    - Initializes the swipe lock provider.
    - Handles swipe actions and locks further swipes after a limit.
    - Resets the swipe count and lockout status.
    - Checks if swipe actions are locked and provides the remaining lockout duration.

* UNDO MANAGER
    - A simple undo manager to keep track of actions and allow undoing the last action.
    - Adds, inserts, and removes actions in a list.
    - Retrieves the length of the list.

## 0.5.23

## 0.5.22

* EncoderDecoder extension support
* Add iterator to operation for easily set limit and reverse

## 0.5.21

* Add data executor
    - load
    - refresh
    - listen
    - listenOnlyModified

* Rename screen loader subclasses
    - ProviderEvent to ScreenLoaderEvent
    - Loader to ScreenLoaderItem

## 0.5.20

* Add some iterator extensions
    - isFound
    - isNotFound
    - findIndex
    - convertAs
    - convertAsyncAs
    - customizeAs
    - customizeAsyncAs

## 0.5.19

* Add color generator utils
* Add number utils
* Add iterator extension
* Remove unnecessary codes
