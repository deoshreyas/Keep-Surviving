extends Node

const UPGRADES = {
	"STAR1":
		{
			"displayname": "Star",
			"level": "Lvl 1",
			"description": "A star is thrown at a random enemy",
			"prerequisite": [],
			"type": "weapon"
		},
	"STAR2":
		{
			"displayname": "Star",
			"level": "Lvl 2",
			"description": "An additional star is thrown",
			"prerequisite": ["STAR1"],
			"type": "weapon"
		},
	"STAR3": {
		"displayname": "Star",
		"description": "Stars now pass through another enemy and do +3 damage",
		"level": "Lvl 3",
		"prerequisite": ["STAR2"],
		"type": "weapon"
	},
	"STAR4": {
		"displayname": "Star",
		"description": "An additional 2 Stars are thrown",
		"level": "Lvl 4",
		"prerequisite": ["STAR3"],
		"type": "weapon"
	},
	"HAND1": {
		"displayname": "Hands",
		"description": "A magical hand will follow you attacking enemies",
		"level": "Lvl 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"HAND2": {
		"displayname": "Hands",
		"description": "The hand will now attack +1 enemy per attack",
		"level": "Lvl 2",
		"prerequisite": ["HAND1"],
		"type": "weapon"
	},
	"HAND3": {
		"displayname": "Hands",
		"description": "The hand will attack +1 enemy per attack",
		"level": "Lvl 3",
		"prerequisite": ["HAND2"],
		"type": "weapon"
	},
	"HAND4": {
		"displayname": "Hands",
		"description": "+5 damage per attack and +20% knockback",
		"level": "Lvl 4",
		"prerequisite": ["HAND3"],
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
