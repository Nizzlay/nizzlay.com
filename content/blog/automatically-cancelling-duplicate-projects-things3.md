+++
title = "Automatically cancelling duplicate projects in Things"
date = "2025-02-11"
description = "I *could* easily just select it, and `CMD(⌘) + Option(⌥) + .` to mark it as cancelled. But being reminded of the past failures is not a great feeling. Thus, let's automate it."

[taxonomies]
tags = ["Automation", "Things", "Productivity", "Python", "Keyboard Maestro"]
+++

I (try to) run my whole life through [Things(3)](https://culturedcode.com/things/), and I've been doing so for many years. Which means I have quite a bunch of recurring tasks and projects. Some of them recur once a year, some of them daily.

The way recurring tasks and projects work in Things3[^1] is that you have a master template, in which you define when it reoccurs, and what tasks are contained in the project. Then, as soon as the moment comes, Things3 will create a new copy of that template.

Which means one of the tricky things with daily recurring projects, is that they can quickly pile up if you didn't get to finish them. A new copy each day.

For recurring tasks you could easily just switch it to recur upon completion instead of a fixed daily reoccurrence. But for projects I don't think that's a good idea. As sometimes it can be that I did do *some* tasks from the project, but not *all* of them. In that scenario it's good to get a fresh copy, which will contain all the tasks again.

So I'll stick with recurring projects, but sometimes life happens. And the system is no good if we don't account for life happening.

So what to do if life happens, and I end up with multiple copies of the same project?

I *could* easily just select it, and `CMD(⌘) + Option(⌥) + .` to mark it as cancelled. But being reminded of the past failures is not a great feeling. Dealing with these kinds of emotions is part of [the fight with procrastination](https://www.nytimes.com/2019/03/25/smarter-living/why-you-procrastinate-it-has-nothing-to-do-with-self-control.html), so it's probably a good thing to prevent the guilty feelings (even if the guilt is only on the subconscious level).

Thus, let's automate it.

Initially I tried using Shortcuts, since that's all the hype. But once again I really just can't get it to do what I want. It's too oversimplified for me. Apparently there's no way to compare time variables[^2], so I can't figure out which is the new project and which is the old one. 

Then I switched to AppleScript. Even installed [Script Debugger](https://latenightsw.com/) to get some actual proper tooling to figure stuff out. But here as well, the frustration got the better of me. In trying to make AppleScript look simple, they've actually made it very hard to use. Just give me actual syntax (and proper errors), not mysterious words that *could* be syntax.

So, Python it is. 

In Python there's a pretty good library for reading Things3 data. And even though I'm not a Python developer, Claude AI is pretty decent[^3] at it. 

For the script to work you'll need to install the unofficial [Things Python API](https://github.com/thingsapi/things.py/), and make sure you enable Things URLs. Click *Manage*, to grab your token.

![Enabling Things URLs in Things3 settings](/enable-things-urls.png)

Then take this code, replace the `THINGS-TOKEN-HERE` with your actual token, and save it somewhere:

```python
import things
import subprocess
from collections import defaultdict
from datetime import datetime

def get_today_items():
    return things.today()

def parse_date(date_str):
    if not date_str:
        return datetime.min  # Return minimum date if no date provided
    
    try:
        # First try ISO format
        return datetime.fromisoformat(date_str)
    except ValueError:
        try:
            # Try standard format
            return datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            print(f"Could not parse date: {date_str}")
            return datetime.min

def cancel_item_via_url_scheme(item_uuid):
    auth_token = "THINGS-TOKEN-HERE"

    url = f"things:///update-project?auth-token={auth_token}&id={item_uuid}&canceled=true"
    
    try:
        # Use macOS open command to trigger URL scheme
        result = subprocess.run(['open', url], 
                                capture_output=True, 
                                text=True, 
                                timeout=5)
        
        if result.returncode == 0:
            print(f"Canceled item with UUID: {item_uuid}")
        else:
            print(f"Error canceling item {item_uuid}: {result.stderr}")
    
    except subprocess.CalledProcessError as e:
        print(f"Subprocess error canceling item {item_uuid}: {e}")
    except Exception as e:
        print(f"Unexpected error canceling item {item_uuid}: {e}")


def check_and_cancel_duplicates():
    # Get all items from Today
    today_items = get_today_items()
    
    # Dictionary to store projects: {project_name: [(item, creation_date)]}
    project_dict = defaultdict(list)
    
    # Print first item to see structure
    if today_items:
        print("\nExample item structure:")
        print(today_items[0])
    
    # Collect all projects and their creation dates
    for item in today_items:
        # Check if item is a project
        if item.get('type') == 'project':
            project_name = item.get('title')
            
            # Try different possible date fields
            creation_date = item.get('creation_date') or item.get('creationDate') or item.get('created')
            
            parsed_date = parse_date(creation_date)
            project_dict[project_name].append((item, parsed_date))
    
    # Check for duplicates and cancel older ones
    for project_name, items in project_dict.items():
        if len(items) > 1:
            # Sort by creation date, newest first
            sorted_items = sorted(items, key=lambda x: x[1], reverse=True)
            print(f"\nFound duplicate project: {project_name}")
            print(f"Keeping newest: Created at {sorted_items[0][1]}")
            
            # Cancel all but the newest
            for item, date in sorted_items[1:]:
                print(f"Canceling duplicate from: {date}")
                cancel_item_via_url_scheme(item['uuid'])

if __name__ == "__main__":
    try:
        check_and_cancel_duplicates()
        print("\nDuplicate check completed successfully")
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        import traceback
        traceback.print_exc()
```

This code will use the Things Python API library to get all the projects from your `Today` view, and iterate through them to figure out if there are duplicates (based on the name). If there are duplicates, it will figure out which one's the newest, and create a list of all the others. Then, since the library is read only, it will use [Things official URL scheme](https://culturedcode.com/things/support/articles/2803573/) to cancel the old duplicates.

You can run the script using: `python3 cancel-duplicates.py`

Finally, let's make sure that the command to run the script is automatically running as well. To automate it, I've created a [Keyboard Maestro](https://www.keyboardmaestro.com/main/) action that triggers every time I wake my laptop.

![Cronjob to trigger on wake, using Keyboard Maestro](/cron-cancel-duplicates-things3.png)

 This process would literally only save me a handful of seconds in time. But [according to XKCD](https://xkcd.com/1205/) I could still get a return on time invested within 5 years or so.

But friction is not only measured in time, it's also measured in emotion. And being reminded by the stuff you didn't finish, is bad for your confidence. Which will lead to procrastination, and decreased productivity. So from that perspective, I feel like it's definitely been worth it.

Did you ever automate anything to save you seconds?

[^1]: The app's name is "Things" but that's kind of an annoying thing to say, as it's also just a word that you would use frequently in this context, so I'll refer to it as "Things3" from now on.

[^2]: Or at least I couldn't figure it out. I could only hard code the comparison. It might exist, but I didn't want to waste too much time on being annoyed with Shortcuts. I tend to move away from Shortcuts quite quickly as I don't really like using it.

[^3]: Nowhere near perfect. But I understand enough Python to be able to fill in the gaps, and prompt for whatever needs to be our next steps.