# Cursor2Swift

Cursor2Swift is a project boilerplate that leverages the power of [XcodeGen](https://github.com/yonaskolb/XcodeGen) to streamline the Xcode project generation process for Swift applications.

## Features

- Automated Xcode project generation
- Simplified project configuration using YAML or JSON
- Easy management of targets, configurations, and schemes
- Seamless integration with version control systems

## Prerequisites

Before you begin, ensure you have the following installed:
- Xcode (latest stable version)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Getting Started

1. Clone this repository:
   ```
   git clone https://github.com/regenrek/Cursor2Swift.git
   cd Cursor2Swift
   ```

2. Customize the `project.yml` file to match your project requirements.

3. Generate the Xcode project:
   ```
   xcodegen generate
   ```

4. Open the generated `.xcodeproj` file and start developing!

## Project Structure

```
Cursor2Swift/
├── Sources/
│   └── (Your Swift source files)
├── Tests/
│   └── (Your test files)
├── Resources/
│   └── (Asset catalogs, storyboards, etc.)
├── project.yml
└── README.md
```

## Customization

Edit the `project.yml` file to customize your project settings, targets, and configurations. Refer to the [XcodeGen documentation](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md) for detailed information on available options.

## Benefits of Using XcodeGen

- **Version Control Friendly**: Keep your Xcode project configuration in a simple, readable format.
- **Reduced Merge Conflicts**: Eliminate `.xcodeproj` merge conflicts in team environments.
- **Consistency**: Ensure project structure consistency across team members and CI systems.
- **Automation**: Easily integrate project generation into your development and CI workflows.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for making Xcode project management a breeze.

---

Feel free to customize this README further to match the specific details and requirements of your Cursor2Swift project. The structure provided gives a solid foundation for explaining your project's purpose, setup process, and the benefits of using XcodeGen in your workflow.