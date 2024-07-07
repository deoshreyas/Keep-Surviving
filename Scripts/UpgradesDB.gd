extends Node

const UPGRADES = {
	"WEAPON1-1":
		{
			"displayname": "Star",
			"level": "Lvl 1",
			"description": "A star is thrown at a random enemy",
			"prerequisite": [],
			"type": "weapon"
		},
	"WEAPON1-2":
		{
			"displayname": "Star",
			"level": "Lvl 2",
			"description": "An additional star is thrown",
			"prerequisite": ["WEAPON1-1"],
			"type": "weapon"
		},
	"WEAPON1-3": {
		"displayname": "Star",
		"description": "Stars now pass through another enemy and do +3 damage",
		"level": "Lvl 3",
		"prerequisite": ["WEAPON1-2"],
		"type": "weapon"
	},
	"WEAPON1-4": {
		"displayname": "Star",
		"description": "An additional 2 Stars are thrown",
		"level": "Lvl 4",
		"prerequisite": ["WEAPON1-3"],
		"type": "weapon"
	},
	"WEAPON3-1": {
		"displayname": "Hands",
		"description": "A magical hand will follow you attacking enemies in a straight line",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"WEAPON3-2": {
		"displayname": "Hands",
		"description": "The hand will now attack an additional enemy per attack",
		"level": "Lvl 2",
		"prerequisite": ["WEAPON3-1"],
		"type": "weapon"
	},
	"WEAPON3-3": {
		"displayname": "Hands",
		"description": "The hand will attack another additional enemy per attack",
		"level": "Lvl 3",
		"prerequisite": ["WEAPON3-2"],
		"type": "weapon"
	},
	"WEAPON3-4": {
		"displayname": "Hands",
		"description": "The hand now does +5 damage per attack and causes 20% additional knockback",
		"level": "Lvl 4",
		"prerequisite": ["WEAPON3-3"],
		"type": "weapon"
	},
	"WEAPON2-1": {
		"displayname": "Spell",
		"description": "A spell is cast and randomly heads somewhere",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"WEAPON2-2": {
		"displayname": "Spell",
		"description": "An additional spell is cast",
		"level": "Lvl 2",
		"prerequisite": ["WEAPON2-1"],
		"type": "weapon"
	},
	"WEAPON2-3": {
		"displayname": "Spell",
		"description": "The spell cooldown is reduced by 0.5 seconds",
		"level": "Lvl 3",
		"prerequisite": ["WEAPON2-2"],
		"type": "weapon"
	},
	"WEAPON2-4": {
		"displayname": "Spell",
		"description": "An additional spell is created and the knockback is increased by 25%",
		"level": "Lvl 4",
		"prerequisite": ["WEAPON2-3"],
		"type": "weapon"
	},
	"ARMOUR1": {
		"displayname": "Armour",
		"description": "Reduces damage by 1 point",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ARMOUR2": {
		"displayname": "Armour",
		"description": "Reduces damage by an additional 1 point",
		"level": "Lvl 2",
		"prerequisite": ["ARMOUR1"],
		"type": "upgrade"
	},
	"ARMOUR3": {
		"displayname": "Armour",
		"description": "Reduces damage by an additional 1 point",
		"level": "Lvl 3",
		"prerequisite": ["ARMOUR2"],
		"type": "upgrade"
	},
	"ARMOUR4": {
		"displayname": "Armour",
		"description": "Reduces damage by an additional 1 point",
		"level": "Lvl 4",
		"prerequisite": ["ARMOUR3"],
		"type": "upgrade"
	},
	"SPEED1": {
		"displayname": "Speed",
		"description": "Movement speed increased by 50%",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"SPEED2": {
		"displayname": "Speed",
		"description": "Movement speed increased by an additional 50%",
		"level": "Lvl 2",
		"prerequisite": ["SPEED1"],
		"type": "upgrade"
	},
	"SPEED3": {
		"displayname": "Speed",
		"description": "Movement speed increased by an additional 50%",
		"level": "Lvl 3",
		"prerequisite": ["SPEED2"],
		"type": "upgrade"
	},
	"SPEED4": {
		"displayname": "Speed",
		"description": "Movement speed increased an additional 50%",
		"level": "Lvl 4",
		"prerequisite": ["SPEED3"],
		"type": "upgrade"
	},
	"SIZE1": {
		"displayname": "Spell Size",
		"description": "Increases the size of spells by 10%",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"SIZE2": {
		"displayname": "Spell Size",
		"description": "Increases the size of spells by an additional 10%",
		"level": "Lvl 2",
		"prerequisite": ["SIZE1"],
		"type": "upgrade"
	},
	"SIZE3": {
		"displayname": "Spell Size",
		"description": "Increases the size of spells by an additional 10%",
		"level": "Lvl 3",
		"prerequisite": ["SIZE2"],
		"type": "upgrade"
	},
	"SIZE4": {
		"displayname": "Spell Size",
		"description": "Increases the size of spells by an additional 10%",
		"level": "Lvl 4",
		"prerequisite": ["SIZE3"],
		"type": "upgrade"
	},
	"SCROLL1": {
		"displayname": "Scroll",
		"description": "Decreases the cooldown of spells by 5%",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"SCROLL2": {
		"displayname": "Scroll",
		"description": "Decreases the cooldown of spells by an additional 5%",
		"level": "Lvl 2",
		"prerequisite": ["SCROLL1"],
		"type": "upgrade"
	},
	"SCROLL3": {
		"displayname": "Scroll",
		"description": "Decreases the cooldown of spells by an additional 5%",
		"level": "Lvl 3",
		"prerequisite": ["SCROLL2"],
		"type": "upgrade"
	},
	"SCROLL4": {
		"displayname": "Scroll",
		"description": "Decreases the cooldown of spells by an additional 5%",
		"level": "Lvl 4",
		"prerequisite": ["SCROLL3"],
		"type": "upgrade"
	},
	"RING1": {
		"displayname": "Ring",
		"description": "Your spells now spawn 1 more additional attack",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"RING2": {
		"displayname": "Ring",
		"description": "Your spells now spawn an additional attack",
		"level": "Lvl 2",
		"prerequisite": ["RING1"],
		"type": "upgrade"
	},
	"HEALTH": {
		"displayname": "Health",
		"description": "Recovers 25 HP",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
