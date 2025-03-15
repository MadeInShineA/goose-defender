extends Node2D

class_name Upgrade

enum UpgradeType {PLAYER_UPGRADE, WEAPON_UPGRADE}

@export var upgrade_type: UpgradeType
@export var upgraded_node: Upgradable
