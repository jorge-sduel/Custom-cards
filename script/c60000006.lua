-- Bejita - Beyond Sayajin God Blue

function c60000006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,60000005,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR))
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60000006.condition)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000006,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c60000006.atcon)
	e2:SetOperation(c60000006.atop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c60000006.spcon2)
	e3:SetTarget(c60000006.sptg2)
	e3:SetOperation(c60000006.spop2)
	c:RegisterEffect(e3)
end

function c60000006.condition(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==1
end

function c60000006.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable()
end
function c60000006.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end

function c60000006.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60000006.filter(c,e,tp)
	return c:IsCode(60000001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60000006.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c60000006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60000006.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60000006.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60000006.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local turnplayer=Duel.GetTurnPlayer()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SkipPhase(turnplayer,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnplayer,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnplayer,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnplayer,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnplayer,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
