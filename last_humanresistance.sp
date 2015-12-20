#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <zombiereloaded>

#define DATA "v1.1"

new Handle:LastHumanscvar;

new Handle:DamageCvar;

// damage types
#define DMG_GENERIC									0
#define DMG_CRUSH										(1 << 0)
#define DMG_BULLET									(1 << 1)
#define DMG_SLASH										(1 << 2)
#define DMG_BURN										(1 << 3)
#define DMG_VEHICLE									(1 << 4)
#define DMG_FALL										(1 << 5)
#define DMG_BLAST										(1 << 6)
#define DMG_CLUB										(1 << 7)
#define DMG_SHOCK										(1 << 8)
#define DMG_SONIC										(1 << 9)
#define DMG_ENERGYBEAM							(1 << 10)
#define DMG_PREVENT_PHYSICS_FORCE		(1 << 11)
#define DMG_NEVERGIB								(1 << 12)
#define DMG_ALWAYSGIB								(1 << 13)
#define DMG_DROWN										(1 << 14)
#define DMG_TIMEBASED								(DMG_PARALYZE | DMG_NERVEGAS | DMG_POISON | DMG_RADIATION | DMG_DROWNRECOVER | DMG_ACID | DMG_SLOWBURN)
#define DMG_PARALYZE								(1 << 15)
#define DMG_NERVEGAS								(1 << 16)
#define DMG_POISON									(1 << 17)
#define DMG_RADIATION								(1 << 18)
#define DMG_DROWNRECOVER						(1 << 19)
#define DMG_ACID										(1 << 20)
#define DMG_SLOWBURN								(1 << 21)
#define DMG_REMOVENORAGDOLL					(1 << 22)
#define DMG_PHYSGUN									(1 << 23)
#define DMG_PLASMA									(1 << 24)
#define DMG_AIRBOAT									(1 << 25)
#define DMG_DISSOLVE								(1 << 26)
#define DMG_BLAST_SURFACE						(1 << 27)
#define DMG_DIRECT									(1 << 28)
#define DMG_BUCKSHOT								(1 << 29)



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

    DamageCvar = CreateConVar("zr_lasthumans_damage", "20", "Damage per hit for the last humans.");




    CreateConVar("zr_lasthumanresistance", DATA, "plugin", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	

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
                        new damageparaelzombi = GetConVarInt(DamageCvar);
                        DealDamage(client,damageparaelzombi,attacker,DMG_SLASH," ");
			return Plugin_Handled;
                }
                return Plugin_Continue;
}

stock DealDamage(nClientVictim, nDamage, nClientAttacker = 0, nDamageType = DMG_GENERIC, String:sWeapon[] = "")
// ----------------------------------------------------------------------------
{
	// taken from: http://forums.alliedmods.net/showthread.php?t=111684
	// thanks to the authors!
	if(	nClientVictim > 0 &&
			IsValidEdict(nClientVictim) &&
			IsClientInGame(nClientVictim) &&
			IsPlayerAlive(nClientVictim) &&
			nDamage > 0)
	{
		new EntityPointHurt = CreateEntityByName("point_hurt");
		if(EntityPointHurt != 0)
		{
			new String:sDamage[16];
			IntToString(nDamage, sDamage, sizeof(sDamage));

			new String:sDamageType[32];
			IntToString(nDamageType, sDamageType, sizeof(sDamageType));

			DispatchKeyValue(nClientVictim,			"targetname",		"war3_hurtme");
			DispatchKeyValue(EntityPointHurt,		"DamageTarget",	"war3_hurtme");
			DispatchKeyValue(EntityPointHurt,		"Damage",				sDamage);
			DispatchKeyValue(EntityPointHurt,		"DamageType",		sDamageType);
			if(!StrEqual(sWeapon, ""))
				DispatchKeyValue(EntityPointHurt,	"classname",		sWeapon);
			DispatchSpawn(EntityPointHurt);
			AcceptEntityInput(EntityPointHurt,	"Hurt",					(nClientAttacker != 0) ? nClientAttacker : -1);
			DispatchKeyValue(EntityPointHurt,		"classname",		"point_hurt");
			DispatchKeyValue(nClientVictim,			"targetname",		"war3_donthurtme");

			RemoveEdict(EntityPointHurt);
		}
	}
}