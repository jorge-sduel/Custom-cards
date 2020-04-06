-- Bending Knight

function c50000075.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000075,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c50000075.condition)
	e1:SetTarget(c50000075.addct)
	e1:SetOperation(c50000075.addc)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000075,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,50000075)
	e2:SetTarget(c50000075.target)
	e2:SetOperation(c50000075.operation)
	c:RegisterEffect(e2)
	--battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c50000075.atlimit)
	c:RegisterEffect(e3)
end

function c50000075.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c50000075.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1999)
end
function c50000075.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1999,2)
	end
end

function c50000075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c50000075.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c50000075.atlimit(e,c)
	return c:IsFaceup() and c:IsCode(50000066)
end