# Impicity

**Impicity** is a foundation iOS app used for controlling Electric Imp imps via the Internet. It is currently configured for iPhone/iPod Touch use only, but iPad UIs can be easily added to the code.

It is able to manage and maintain a list of imps and their agents' URL codes to allow developers to operate multiple imps and switch between them as necessary.

The interaction between a selected imp and its agent are managed in `ViewController.m`, with the appropriate UI being defined in `main.storyboard`, which is accessed through Xcode.

Other objects maintain and manage a list of imps, which is preserved between application closures. These are generic to whatever interaction a given developer requires between an imp and its agent, and the UI that controls that interaction.

