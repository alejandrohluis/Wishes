# A guide to making your own wishing addons

So, you wish to make your very own wishes? ~~(ok I'll stop with the puns)~~

It is highly recommendable to read all the code if you get stuck at some part to understand the flow of the mod.

The basic workflow is the following:
1. Summon the ritual in some way. 
   - This creates a server-side session with the available wishes, their connection between the ID and the effects, and then starts the wishing window
   - This also immediately consumes the durability of the item used to summon the ritual.
2. The window gets initialised with the data recieved from the ritual summoned
3. The panel gets created and initialised with the window

...
After the player clicks an item inside the panel:
1. Depending on the wish's options:
  - If its an optionless wish, skips to step 2.
  - If the wish has a category or options, creates and displays the list of options for that wish.
    - If the option is a final one (as in, it's not a category), skips to step 2.
    - If it is a category, repeat this step.
2. After selecting the wish and hitting OK, send a command to the server asking to perform the wish.
3. The server receives it, and checks: 
  - if there is a wishing session started for that player
  - if the wish exists
  - if the wish can be performed
4. If all the previous conditions are true, the server performs the effect linked to the wish's ID
5. After doing that, consumes the wishes available based on the cost and sends the player a command to update their remaining wishes.
6. If the player does not have wishes remaining in his session, the session closes and sends a command to the player's window to close itself.


## Adding a ritual
This will be the most independent way of adding your addon.

What you will need is the following:
- Basic requirements for any mod: a poster image, an icon, mod.info with a dependency on `Wishes`.

- A portrait image for your ritual. Not to be confused with a poster image.
  - This image will be displayed when you summon the ritual at the left of the panel.
  - Ideally 289x560 pixels size to avoid stretching, or any texture similar to that resolution.
  - It does not need to be in a `portrait` folder, but it might help you to keep things tidy.

- A client-side lua file to add wish definitions
  - This file will add a connection between: the asked wishID, the translation for that wish and its description, the cost of the wish, and if it has options, the options and filtering lists of the wish.
  - Keep in mind that these connections due to being purely client-side, will only work for displaying the wishes on the panel. The effect the wish grants' only relation is the wishID which will be corroborated by the server later on.
  - For references, check `genie_wishDefinitions.lua` in TheAnnoyingGenie / `db_WishDefinitions.lua` in DragonBalls.
  - For further information on the definitions, check `client/WishDefinitions.lua`.

- A server-side lua file which starts the wishing session and menu.
  - This file's purpose is to create the wishing session, which includes the ritual being used, the amount of wishes granted, each wish used by the ritual and it's true cost; alongside starting the window with the data from this session. You do not need to create the window, just need to start it using the `DPWishes.Action:startWishingMenu` function.
  - Currently implemented mods use recipes to summon the ritual due to being the most simple to implement and work around, but it's not required to be a recipe. Further future rituals will use other methods.
  - For references, check `genie_wishing_menu.lua` in TheAnnoyingGenie / `db_wishing_menu.lua` in DragonBalls.
  - For further information on the session and windows, check `server/WishAction.lua` and `client/ISWishingWindow`.

- A shared-side lua file to add your own brand new effects or options if needed.
  - This file is not required if all your ritual's wishes uses only the base effects/options.
  - For references, check `genie_wishAttributes.lua` in TheAnnoyingGenie / `db_wishAttributes.lua` in DragonBalls.

- Other things include basic stuff like:
  - Items (if you use an item to do the ritual).
  - Translations for each wish, description and ritual title.
  - Sandbox options if any where used, alongside its translations.

## Adding wishes
To add your own new wishes you will need:

- A client-side lua file to add wish definitions
  - This file will add a connection between: the asked wishID, the translation for that wish and its description, the cost of the wish, and if it has options, the options and filtering lists of the wish.
  - Keep in mind that these connections due to being purely client-side, will only work for displaying the wishes on the panel. The effect the wish grants' only relation is the wishID which will be corroborated by the server later on.
  - For references, check `genie_wishDefinitions.lua` in TheAnnoyingGenie / `db_WishDefinitions.lua` in DragonBalls.
  - For further information on the definitions, check `client/WishDefinitions.lua`.

- A shared-side lua file.
  - This file is meant to add the effects and/or options you will need for your wish.
  - For references, check `genie_wishAttributes.lua` in TheAnnoyingGenie / `db_wishAttributes.lua` in DragonBalls.

- If you plan on adding them to any basic ritual:
  - Check if in the file `genie_wishing_menu.lua` you have on your pc has the function `DPWishes.Action:GenieLampCreateSession(playerID)`
    - If it does, you simply need to hook this function and override it. This is done by: 
      1. create a local var of the function, for example: 
         ```lua
         local og_call = DPWishes.Action.GenieLampCreateSession
         ```
      2. create a function with the same name and parameters as the original function
      3. inside that, create a local variable and set it to the returned session of calling the `og_call` variable with the playerID
      4. add your wishes to the session obtained
      5. return the session
    - If not, you will need to override the entire function used to summon the ritual, copy the code and just add the wishes below the rest