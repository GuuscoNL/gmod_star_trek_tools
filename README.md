# Star Trek in Gmod!

This addon adds multiple functional engineering and medical tools from the Star Trek universe, including a simple medical system.

**[ONI SWEP Base](https://steamcommunity.com/sharedfiles/filedetails/?id=2633296847) is required for use!**

It was created in cooperation with the **"TBN - Star Trek RP"** Community Project  
More Information at: https://discord.gg/dx7KDm2BHv  
[![Join Discord](https://i.imgur.com/25uwYnj.png)](https://discord.gg/dx7KDm2BHv)

---

# Engineering tools

## Hyperspanner
A tool used to repair the ship's systems.  
*Hold LMB to use. Will hurt players and NPCs.*

## Laser Scalpel
A specialized medical instrument used to create incisions in various tissues.  
*Hold LMB to use. Will slightly hurt players and NPCs.*

## Odn Scanner
A high-tech instrument used to diagnose, calibrate, and repair circuits.  
*Press LMB to toggle scanner.*

## Sonic Driver
A sonic driver was a standard tool used in the Federation during the 2360s.  
*Press LMB to toggle.*

# Medical tools

This addon comes with a simple medical system. There are 3 medical tools and each can only heal part of the player, requiring all 3 to fully heal someone from low health.

## Hypospray
A medical device used to deliver medication or substances into the body without needles.

- Press LMB to use.
- Press R to inject yourself.
- Press RMB to revive player (if implemented by gamemode)

*Will slowly heal players over time. If they are below 20% health, it heals faster. Will not heal NPCs.*

## Autosuture
Seals wounds and promotes healing.  
*Hold LMB to use. Only heals from 25% to 75% health. Outside this range will trigger an error sound.*

## Dermal Regenerator
Heals minor skin wounds, such as cuts and burns.  
*Hold LMB to use. Only heals from 75% to 100% health. Outside this range will trigger an error sound.*

# Hooks

For the hypospray, a hook will be triggered when someone tries to revive another:

```lua
hook.Add("star_trek.tools.hypospray.revive", "my_hook", function(owner, entity)
end)
```
**Parameters:**

1. `owner`: Owner of the SWEP.
2. `entity`: Entity that got hit.

**Return:**

`true`: Play animation

*It is your responsibility to check if the entity is a player or ragdoll and to perform the revive.*

# Find a bug?

If you found any bugs, please create an [issue on GitHub](https://github.com/GuuscoNL/gmod_star_trek_tools/issues).

# Additional Notes

You can use the [STM Handheld Tricorders](https://steamcommunity.com/sharedfiles/filedetails/?id=2792719082) to scan players and see how much medication they have in their systems and what kind of wound they have.

---

# Credits

| Contributor | Role |
|-------------|------|
| [Oninoni](https://steamcommunity.com/id/oninoni) | SWEP base |
| [GuuscoNL](https://steamcommunity.com/profiles/76561198168362402) | Lua |
| [CrazyCanadian](https://steamcommunity.com/profiles/76561198445454854) | High quality models for the tools |
| [Nova Canterra](https://steamcommunity.com/id/novacanterra) | Emotional support, sounds |
| [paethon](https://sketchfab.com/paethon) | Hypospray model |

**Maps used in addon images:**  
[Star Trek - Intrepid Class](https://steamcommunity.com/sharedfiles/filedetails/?id=2818321513)

---

# Disclaimer

> **Do not copy, reupload, edit, or in any other way distribute the content that comes with this addon. It is all forbidden by the Steam User Agreement and considered a copyright infringement.**
