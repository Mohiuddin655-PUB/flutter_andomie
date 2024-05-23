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
