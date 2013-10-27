require 'solstice.nwn.ctypes.foundation'
require 'solstice.nwn.ctypes.2da'
require 'solstice.nwn.ctypes.vector'
require 'solstice.nwn.ctypes.location'
require 'solstice.nwn.ctypes.effect'
require 'solstice.nwn.ctypes.itemprop'
require 'solstice.nwn.ctypes.object'
require 'solstice.nwn.ctypes.area'
require 'solstice.nwn.ctypes.aoe'
require 'solstice.nwn.ctypes.client'
require 'solstice.nwn.ctypes.combat'
require 'solstice.nwn.ctypes.creature'
require 'solstice.nwn.ctypes.door'
require 'solstice.nwn.ctypes.encounter'
require 'solstice.nwn.ctypes.feat'
require 'solstice.nwn.ctypes.item'
require 'solstice.nwn.ctypes.module'
require 'solstice.nwn.ctypes.nwnx'
require 'solstice.nwn.ctypes.skill'
require 'solstice.nwn.ctypes.placeable'
require 'solstice.nwn.ctypes.trigger'
require 'solstice.nwn.ctypes.waypoint'

local ffi = require 'ffi'

-- clib functions
ffi.cdef[[
char *strdup(const char *s);
]]

-- Exalt NWN Functions
ffi.cdef[[
CGameObject *nwn_GetObjectByID (nwn_objid_t oid);
CGameObject *nwn_GetObjectByStringID (const char *oid);
CNWSPlayer *nwn_GetPlayerByID (nwn_objid_t oid);

bool nwn_GetKnowsFeat (const CNWSCreatureStats *stats, int feat);
int nwn_GetKnowsSkill (const CNWSCreatureStats *stats, int skill);
int nwn_GetLevelByClass (const CNWSCreatureStats *stats, int cl);
CNWSStats_Level *nwn_GetLevelStats (const CNWSCreatureStats *stats, int level);
int64_t nwn_GetWorldTime (uint32_t *time_2880s, uint32_t *time_msec);
void nwn_UpdateQuickBar (CNWSCreature *cre);
void nwn_ExecuteScript (const char *scr, nwn_objid_t oid);
]]

-- 2da.h
ffi.cdef [[
C2DA *nwn_GetCached2da(const char *file);
int nwn_Get2daColumnCount(C2DA *tda);
int nwn_Get2daRowCount(C2DA *tda);
char * nwn_Get2daString(C2DA *tda, const char* col, uint32_t row);
char * nwn_Get2daStringIdx(C2DA *tda, int col, uint32_t row);
int32_t nwn_Get2daInt(C2DA *tda, const char* col, uint32_t row);
int32_t nwn_Get2daIntIdx(C2DA *tda, int col, uint32_t row);
float nwn_Get2daFloat(C2DA *tda, const char* col, uint32_t row);
float nwn_Get2daFloatIdx(C2DA *tda, int col, uint32_t row);
]]

-- area.h
ffi.cdef [[
CNWSArea *nwn_GetAreaByID(uint32_t id);
bool      nwn_ClearLineOfSight(CNWSArea *area, Vector pointa, Vector pointb);
float     nwn_GetGroundHeight(CNWSArea *area, CScriptLocation *loc);
bool      nwn_GetIsWalkable(CNWSArea *area, CScriptLocation *loc);
]]

-- cexolocstring.h
ffi.cdef [[
CExoLocStringElement *nwn_GetCExoLocStringElement(CExoLocString* str, uint32_t locale);
const char           *nwn_GetCExoLocStringText(CExoLocString* str, uint32_t locale);
]]

-- rules.h
ffi.cdef [[
bool      nwn_GetIsClassBonusFeat(int32_t cls, uint16_t feat);
bool      nwn_GetIsClassGeneralFeat(int32_t cls, uint16_t feat);
uint8_t   nwn_GetIsClassGrantedFeat(int32_t cls, uint16_t feat);
bool      nwn_GetIsClassSkill (int32_t idx, uint16_t skill);
CNWSkill *nwn_GetSkill(uint32_t skill);
]]

-- creature.h
ffi.cdef [[
CNWSCreature *nwn_GetCreatureByID(uint32_t oid);

void      nwn_ActionUseItem(CNWSCreature *cre, CNWSItem* it, CNWSObject *target, CNWSArea* area, CScriptLocation *loc, int prop);
void      nwn_AddKnownFeat(CNWSCreature *cre, uint16_t feat, uint32_t level);
int       nwn_AddKnownSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_level);
uint32_t  nwn_CalculateSpellDC(CNWSCreature *cre, uint32_t spellid);
void      nwn_DecrementFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
int8_t    nwn_GetAbilityModifier(CNWSCreatureStats *stats, int8_t abil, bool armorcheck);
int       nwn_GetAttacksPerRound(CNWSCreatureStats *stats);
int8_t    nwn_GetBaseSavingThrow(CNWSCreature *cre, uint32_t type);
int       nwn_GetBonusSpellSlots(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetCriticalHitMultiplier(CNWSCreatureStats *stats, bool offhand);
int       nwn_GetCriticalHitRange(CNWSCreatureStats *stats, bool offhand);
uint16_t  nwn_GetDamageFlags(CNWSCreature *cre);
int32_t   nwn_GetDexMod(CNWSCreatureStats *stats, bool armor_check);
bool      nwn_GetEffectImmunity(CNWSCreature *cre, int type, CNWSCreature *vs);
int       nwn_GetFeatRemainingUses(CNWSCreatureStats *stats, uint16_t feat);
bool      nwn_GetFlanked(CNWSCreature *cre, CNWSCreature *target);
bool      nwn_GetFlatFooted(CNWSCreature *cre);
int       nwn_GetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
bool      nwn_GetKnowsSpell(CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id);
bool      nwn_GetHasFeat(CNWSCreatureStats *stats, uint16_t feat);
int32_t   nwn_GetHasNthFeat(CNWSCreature *cre, uint16_t start, uint16_t stop);
bool      nwn_GetIsInvisible(CNWSCreature *cre, CNWSObject *obj);
bool      nwn_GetIsVisible(CNWSCreature *cre, nwn_objid_t target);
CNWSItem *nwn_GetItemInSlot(CNWSCreature *cre, uint32_t slot);
double    nwn_GetMaxAttackRange(CNWSCreature *cre, nwn_objid_t target);
int       nwn_GetMaxSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx);
int       nwn_GetRelativeWeaponSize(CNWSCreature *cre, CNWSItem *weapon);
int       nwn_GetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int8_t    nwn_GetSkillRank(CNWSCreature *cre, uint8_t skill, CNWSObject *vs, bool base);
int       nwn_GetTotalFeatUses(CNWSCreatureStats *stats, uint16_t feat);
int       nwn_GetTotalKnownSpells (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level);
int       nwn_GetTotalNegativeLevels(CNWSCreatureStats *stats);
void      nwn_JumpToLimbo(CNWSCreature *cre);
void      nwn_NotifyAssociateActionToggle(CNWSCreature *cre, int32_t mode);
int       nwn_RecalculateDexModifier(CNWSCreatureStats *stats);
int       nwn_RemoveKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_id);
int       nwn_ReplaceKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_id, uint32_t sp_new);
void      nwn_ResolveItemCastSpell(CNWSCreature *cre, CNWSObject *target);
void      nwn_ResolveSafeProjectile(CNWSCreature *cre, uint32_t delay, int attack_num);
uint8_t   nwn_SetAbilityScore(CNWSCreatureStats *stats, int abil, int val);
void      nwn_SetActivity(CNWSCreature *cre, int32_t a, int32_t b);
void      nwn_SetAnimation(CNWSCreature *cre, uint32_t anim);
void      nwn_SetCombatMode(CNWSCreature *cre, uint8_t mode);
int       nwn_SetKnownSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_id);
int       nwn_SetMemorizedSpell (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_idx, uint32_t sp_spell, uint32_t sp_meta, uint32_t sp_flags);
int       nwn_SetRemainingSpellSlots (CNWSCreature *cre, uint32_t sp_class, uint32_t sp_level, uint32_t sp_slots);
void      nwn_SendMessage(uint32_t mode, uint32_t id, const char *msg, uint32_t to);
]]

-- effect.h
ffi.cdef [[
void nwn_EffectSetNumIntegers(CGameEffect *eff, uint32_t num);
]]

-- faction.h
ffi.cdef [[
int32_t               nwn_GetFactionId(uint32_t id);
void                  nwn_SetFactionId(nwn_objid_t id, int32_t faction);
]]

-- item.h
ffi.cdef [[
CNWSItem        *nwn_GetItemByID(uint32_t id);
uint8_t          nwn_GetItemSize(CNWSItem *item);
CNWItemProperty *nwn_GetPropertyByType(CNWSItem *item, uint16_t type);
bool             nwn_HasPropertyType(CNWSItem *item, uint16_t type);
CNWBaseItem     *nwn_GetBaseItem(uint32_t basetype);
]]

-- message.h
--ffi.cdef [[
--]]

-- module.h
ffi.cdef [[
CNWSModule *nwn_GetModule();
]]

-- object.h
ffi.cdef [[
void             nwn_DelayCommand(uint32_t obj_id, double delay, void *vms);

void             nwn_DeleteLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalInt(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalObject(CNWSScriptVarTable *vt, const char *var_name);
void             nwn_DeleteLocalString(CNWSScriptVarTable *vt, const char *var_name);

void             nwn_DoCommand(CNWSObject *obj, void *vms);

CGameEffect*     nwn_GetEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                    const int eff_spellid, const int eff_type, const int eff_int0, const int eff_int1);

int              nwn_GetHasEffect(const CNWSObject *obj, const nwn_objid_t eff_creator,
                                       const int eff_spellid, const int eff_type, const int eff_int0);

int32_t          nwn_GetLocalInt(CNWSScriptVarTable *vt, const char *var_name);
float            nwn_GetLocalFloat(CNWSScriptVarTable *vt, const char *var_name);
CScriptLocation  nwn_GetLocalLocation(CNWSScriptVarTable *vt, const char *var_name);
uint32_t         nwn_GetLocalObject(CNWSScriptVarTable *vt, const char *var_name);
const char      *nwn_GetLocalString(CNWSScriptVarTable *vt, const char *var_name);

CScriptVariable *nwn_GetLocalVariableByPosition (CNWSScriptVarTable *vt, int idx);
int              nwn_GetLocalVariableCount (CNWSScriptVarTable *vt);
bool             nwn_GetLocalVariableSet(CNWSScriptVarTable *vt, const char *var_name, int8_t type);

void             nwn_SetLocalFloat(CNWSScriptVarTable *vt, const char *var_name, float value);
void             nwn_SetLocalInt(CNWSScriptVarTable *vt, const char *var_name, int32_t value);
void             nwn_SetLocalLocation(CNWSScriptVarTable *vt, const char *var_name, CScriptLocation * value);
void             nwn_SetLocalObject(CNWSScriptVarTable *vt, const char *var_name, uint32_t id);
void             nwn_SetLocalString(CNWSScriptVarTable *vt, const char *var_name, const char *value);

void             nwn_RemoveEffectById(CNWSObject *obj, uint32_t id);
void             nwn_SetTag(CNWSObject *obj, const char *value);
]]

-- stack.h
ffi.cdef [[
void      nwn_ExecuteCommand(int command, int num_args);

uint32_t  nwn_GetCommandObjectId();
uint32_t  nwn_SetCommandObjectId(uint32_t obj);

bool      nwn_StackPopBoolean();
int       nwn_StackPopInteger();
float     nwn_StackPopFloat();
char     *nwn_StackPopString();
Vector   *nwn_StackPopVector();
uint32_t  nwn_StackPopObject();
void      nwn_StackPushBoolean(bool value);
void     *nwn_StackPopEngineStructure(uint32_t type);
void      nwn_StackPushFloat(float value);
void      nwn_StackPushInteger(int value);
void      nwn_StackPushString(const char *value);
void      nwn_StackPushVector(Vector *value);
void      nwn_StackPushObject(uint32_t value);
void      nwn_StackPushEngineStructure(uint32_t type, void * value);
]]

-- waypoint.h
ffi.cdef [[
CNWSWaypoint *nwn_GetWaypointByID(uint32_t id);
]]

-- effects/creation.h
ffi.cdef [[
CGameEffect * nwn_CreateEffect(int show_icon);
    
CGameEffect * effect_ability(int32_t ability, int32_t amount);
CGameEffect * effect_ac(int32_t amount, int32_t modifier_type, int32_t damage_type);

CGameEffect * effect_appear(bool animation);
CGameEffect * effect_aoe(int32_t aoe, const char * enter, const char * heartbeat, const char * exit);

CGameEffect * effect_attack(int32_t amount, int32_t modifier_type);

CGameEffect * effect_beam(int32_t beam, int32_t creator, int32_t bodypart, int32_t miss_effect);
CGameEffect * effect_blindness();
CGameEffect * effect_feat (int32_t feat);
CGameEffect * effect_charmed();
CGameEffect * effect_concealment(int32_t amount, int32_t miss_type);
CGameEffect * effect_confused();
CGameEffect * effect_curse(int32_t str, int32_t dex, int32_t con,
			   int32_t intg, int32_t wis, int32_t cha);

CGameEffect * effect_cutscene_dominated();
CGameEffect * effect_cutscene_ghost();
CGameEffect * effect_cutscene_immobilize();
CGameEffect * effect_cutscene_paralyze();

CGameEffect * effect_damage(int32_t amount, int32_t damage_type, int32_t power);
CGameEffect * effect_damage_decrease(int32_t amount, int32_t damage_type, int32_t attack_type);
CGameEffect * effect_damage_increase(int32_t amount, int32_t damage_type, int32_t attack_type);

/*
CGameEffect * effect_DamageRangeDecrease(start, stop, damage_type, attack_type);
CGameEffect * effect_DamageRangeIncrease(start, stop, damage_type, attack_type);
*/

CGameEffect * effect_damage_immunity(int32_t damage_type, int32_t percent);
CGameEffect * effect_damage_reduction(int32_t amount, int32_t power, int32_t limit);
CGameEffect * effect_damage_resistance(int32_t damage_type, int32_t amount, int32_t limit);
CGameEffect * effect_damage_shield(int32_t amount, int32_t random, int32_t damage_type);

CGameEffect * effect_darkness();
CGameEffect * effect_dazed();
CGameEffect * effect_deaf();
CGameEffect * effect_death(bool spectacular, bool feedback);
CGameEffect * effect_disappear(bool animation);
CGameEffect * effect_disappear_appear(CScriptLocation location, bool animation);

CGameEffect * effect_disarm();
CGameEffect * effect_disease(int32_t disease);

CGameEffect * effect_dispel_all(int32_t diseasecaster_level);
CGameEffect * effect_dispel_best(int32_t diseasecaster_level);

CGameEffect * effect_dominated();
CGameEffect * effect_entangle();
CGameEffect * effect_ethereal();
CGameEffect * effect_frightened();
CGameEffect * effect_haste();

CGameEffect * effect_heal(int32_t amount);

CGameEffect * effect_hp_change_when_dying(float hitpoint_change);

/*
CGameEffect * effect_hp_decrease(int32_t amount);
CGameEffect * effect_hp_increase(int32_t amount);
*/

CGameEffect * effect_icon(int32_t icon);

CGameEffect * effect_immunity(int32_t immunity, int32_t percent);

CGameEffect * effect_invisibility(int32_t type);

CGameEffect * effect_knockdown();

CGameEffect * effect_link(CGameEffect *child, CGameEffect *parent);

CGameEffect * effect_miss_chance(int32_t amount, int32_t miss_type);

CGameEffect * effect_additional_attacks(int32_t amount);
CGameEffect * effect_move_speed(int32_t amount);
CGameEffect * effect_negative_level(int32_t amount, bool hp_bonus);

CGameEffect * effect_paralyze();
CGameEffect * effect_petrify();
CGameEffect * effect_poison(int32_t type);

CGameEffect * effect_polymorph(int32_t polymorph, bool locked);

CGameEffect * effect_regen(int32_t amount, float interval);

CGameEffect * effect_resurrection();
CGameEffect * effect_sanctuary(int32_t dc);

CGameEffect * effect_save(int32_t save, int32_t amount, int32_t save_type);

CGameEffect * effect_see_invisible();
CGameEffect * effect_silence();
CGameEffect * effect_skill(int32_t skill, int32_t amount);
CGameEffect * effect_sleep();
CGameEffect * effect_slow();
CGameEffect * effect_spell_failure(int32_t percent, int32_t spell_school);

CGameEffect * effect_spell_immunity(int32_t spell);

CGameEffect * effect_spell_absorbtion(int32_t max_level, int32_t max_spells, int32_t school);
CGameEffect * effect_spell_resistance(int32_t amount);
CGameEffect * effect_stunned();

CGameEffect * effect_summon(const char * resref, int32_t vfx, float delay, bool appear);
CGameEffect * effect_swarm(bool looping, const char * resref1, const char * resref2, const char * resref3, const char * resref4);

CGameEffect * effect_hp_temporary(int32_t amount);
CGameEffect * effect_time_stop();
CGameEffect * effect_true_seeing();
CGameEffect * effect_turned();

CGameEffect * effect_turn_resistance(int32_t amount);
CGameEffect * effect_ultravision();
CGameEffect * effect_visual(int32_t id, bool miss);
CGameEffect * effect_wounding (int32_t amount);
]]

-- effects/itemprop.h
ffi.cdef [[
CGameEffect * ip_create(bool show_icon);
CGameEffect * ip_set_values(CGameEffect *eff, int type, int subtype, int cost,
			     int cost_val, int param1, int param1_val,
			     int uses_per_day, int chance);

CGameEffect * ip_ability(int32_t ability, int32_t bonus);

CGameEffect * ip_ac(int32_t bonus, uint8_t ac_type);

CGameEffect * ip_enhancement(int32_t bonus);

CGameEffect * ip_weight_increase(int32_t amount);
CGameEffect * ip_weight_reduction(int32_t amount);

CGameEffect * ip_feat(int32_t feat);

CGameEffect * ip_spell_cast(int32_t spell, int32_t uses);
CGameEffect * ip_spell_slot(int32_t cls, int32_t level);

CGameEffect * ip_damage(int32_t damage_type, int32_t damage);
CGameEffect * ip_damage_extra(int32_t damage_type, bool is_ranged);

CGameEffect * ip_damage_immunity(int32_t damage_type, int32_t amount);
CGameEffect * ip_damage_penalty(int32_t penalty);
CGameEffect * ip_damage_reduction(int32_t enhancement, int32_t soak);
CGameEffect * ip_damage_resistance(int32_t damage_type, int32_t amount);

CGameEffect * ip_damage_vulnerability(int32_t damage_type, int32_t amount);

CGameEffect * ip_darkvision();

CGameEffect * ip_skill(int32_t skill, int32_t amount);

CGameEffect * ip_container_reduced_weight(int32_t amount);

CGameEffect * ip_haste();
CGameEffect * ip_holy_avenger();
CGameEffect * ip_immunity_misc(int32_t immumity_type);
CGameEffect * ip_improved_evasion();

CGameEffect * ip_spell_resistance(int32_t amount);

CGameEffect * ip_save(int32_t save_type, int32_t amount);
CGameEffect * ip_save_vs(int32_t save_type, int32_t amount);

CGameEffect * ip_keen();

CGameEffect * ip_light(int32_t brightness, int32_t color);

CGameEffect * ip_mighty(int32_t modifier);

CGameEffect * ip_no_damage();

CGameEffect * ip_onhit(int32_t prop, int32_t dc, int32_t special);

CGameEffect * ip_regen(int32_t amount);

CGameEffect * ip_immunity_spell(int32_t spell);

CGameEffect * ip_immunity_spell_school(int32_t school);

CGameEffect * ip_thieves_tools(int32_t modifier);

CGameEffect * ip_attack(int32_t bonus);

CGameEffect * ip_unlimited_ammo(int32_t ammo);

CGameEffect * ip_use_align(int32_t align_group);
CGameEffect * ip_use_class(int32_t cls);
CGameEffect * ip_use_race(int32_t race);
CGameEffect * ip_use_salign(int32_t nAlignment);

CGameEffect * ip_regen_vampiric(int32_t amount);

CGameEffect * ip_trap(int32_t level, int32_t trap_type);

CGameEffect * ip_true_seeing();

CGameEffect * ip_onhit_monster(int32_t prop, int32_t special);

CGameEffect * ip_turn_resistance(int32_t modifier);

CGameEffect * ip_massive_critical(int32_t damage);

CGameEffect * ip_freedom();

CGameEffect * ip_monster_damage(int32_t damage);

CGameEffect * ip_immunity_spell_level(int32_t level);

CGameEffect * ip_special_walk(int32_t walk);

CGameEffect * ip_healers_kit(int32_t modifier);

CGameEffect * ip_material(int32_t material);

CGameEffect * ip_onhit_castspell(int32_t spell, int32_t level);

CGameEffect * ip_quality(int32_t quality);

CGameEffect * ip_additional(int32_t addition);

CGameEffect * ip_visual_effect(int32_t effect);
]]

-- Solstice Functions
ffi.cdef [[
void ns_ActionDoCommand(CNWSObject * object, uint32_t token);
int  ns_BitScanFFS(uint32_t mask);
void ns_DelayCommand(CNWSObject *obj, float delay, uint32_t token);
void ns_RepeatCommand(CNWSObject *obj, float delay, uint32_t token);


ChatMessage   *Local_GetLastChatMessage();
CombatMessage *Local_GetLastCombatMessage();
EquipEvent    *Local_GetLastEquipEvent();
EventEffect   *Local_GetLastEffectEvent();
EventItemprop *Local_GetLastItemPropEvent();
CGameEffect   *Local_GetLastDamageEffect();
Event         *Local_GetLastNWNXEvent();
void           Local_NWNXLog(int level, const char* log);
]]
