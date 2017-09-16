# Specification Tooling

## Problem statement

When you have a number of feature files for a problem domain you want to get a view for all the placeholders and the set of values used in the placedholders to ensure consistency.

## Solution Overview

Place gherkin feature files together in a directory.

Run ```gulp extract```

The output in the build/placeholder directory will be a json file with the directory name.

## Example

Given a feature file

```
Feature: A sample feature

Scenario Outline: Scenario1
Given <Placeholder.Given>
When <Placeholder.When>
Then <Placeholder.Then>

Examples:
| Placeholder.Given | Placeholder.When | Placeholder.Then |
| Given1 |  Then1 | When1 |
| Given2 |  Then2 | When2 |
```

When you run the extractor

Then the json file generated is
```
{
 "Placeholder": {
  "Given": {
   "domain": [
    "Given1",
    "Given2"
   ]
  },
  "When": {
   "domain": [
    "Then1",
    "Then2"
   ]
  },
  "Then": {
   "domain": [
    "When1",
    "When2"
   ]
  }
 }
} 
```