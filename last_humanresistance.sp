#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <zombiereloaded>

#define DATA "v1.2"

new Handle:LastHumanscvar;

new Handle:DamageCvar;

public Plugin:myinfo =
{
    name = "SM ZR Last Human Resistance",
    author = "Franc1sco steam: franug",
    description = "For last humans",
    version = DATA,
    url = "http://servers-cfg.foroactivo.com/"
};

public OnPluginStart()
{
	LastHumanscvar = CreateConVar("zr_lasthumans", "1", "Number of humans alive for block infect.");

	DamageCvar = CreateConVar("zr_lasthumans_damage", "20.0", "Damage per hit for the last humans.");

	CreateConVar("zr_lasthumanresistance", DATA, "plugin", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
}

public Action:ZR_OnClientInfect(&client, &attacker, &bool:motherInfect, &bool:respawnOverride, &bool:respawn)
{
	new Humanos = 0;
	for(new i=1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && ZR_IsClientHuman(i))
		{
			Humanos++;
		}
	}

	if (Humanos <= GetConVarInt(LastHumanscvar))
	{
		SDKHooks_TakeDamage(client, attacker, attacker, GetConVarFloat(DamageCvar), DMG_SLASH, -1, NULL_VECTOR, NULL_VECTOR);  
		return Plugin_Handled;
 	}
	return Plugin_Continue;
}