# TipCalculator
iOS app to calculate tip percentage based on default or custom tip percentage.

# Pre-work - TipCalculator

TipCalculator is a tip calculator application for iOS.

Submitted by: Deepthy

Time spent: 6 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [ ] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] User can choose to not tip on the tax amount. This feature is optional and can be turned on/off using the switch in the settings
- [x] Added a slider to calculate tip from a set minimum and maximum percentage. The slider is optional and can be displayed using a switch in the settings
- [x] The Segmented control's display values changes depending on the default percentage.


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/dr28/TipCalculator/blob/master/TipCalculatorDemo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** The iOS app development platform looks interesting. Designing and developing an iOS app is made easier with Xcode and Swift. UI can be created with less effort in the storyboard. Also programming using Swift seems easy.

Outlets provides reference to the objects in the storyboard. Outlets allows to access and manipulate the object from the source code at runtime.

An action is the code that is executed when an event occurs. For example, when a button in the interface is clicked, the action method linked to the button's clicked event is executed.


The outlets and actions are configured in the storyboard's xml file under connections. When an outlet is created from the storyboard to the view controller, Xcode configures the xml by adding the outlet with an <outlet> tag under the <connections> tags for the specific view controller. When the view controller is loaded from storyboard, the system instantiates the view hierarchy and assigns the values to all the view controller's outlets. The values would be assigned by the time the viewDidLoad() of the view controller is called.
Similarly when an action is created for an object, the action will be configured with an <action> tag under the <connections> tag for the specific object.

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** Strong reference cycle for closures occur when strong references between class instance and closure are keeping each other alive. Strong reference are created when a closure is assigned to a property of class instance and the closure has access to property or method of the instance. 

When a class with a property that holds a closure and the closure access the instance's property or methods, the instance property hold a strong reference to the closure and the closure holds a strong reference back to the instance. So a reference cycle is created. If the variable holding the instance is set to nil, only the variable's strong reference to the instance will be broken. The instance and the closure will not be deallocated. 

This can be resolved by defining a capture list in the closure's definition. The capture list defines a rule to use for the references type in closure. In the capture list, the reference are declared weak or unowned references with the use of the "weak" or "unowned" keyword. The capture list is enclosed within a square brackets with each reference separated by commas and is the first line within the closure. The keyword "unowned" is used if both the closure and the instance captured in the closure refers to each other and both these will be deallocated at the same time. The keyword "weak" is used when the captured reference becomes nil in the future. The weak references are optional type and becomes nil when the instance they reference is deallocated.


## License

Copyright 2017 Deepthy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
