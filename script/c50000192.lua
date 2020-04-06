-- Yoyo Dino Helpful Orange

function c50000192.initial_effect(c)
	c:SetSPSummonOnce(50000192)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50000192.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000192,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c50000192.sptg)
	e2:SetOperation(c50000192.spop)
	c:RegisterEffect(e2)
end

function c50000192.spfilter(c)
	return c:IsFaceup() and c:IsCode(50000191)
end
function c50000192.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c50000192.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function c50000192.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c50000192.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50000193,0x70A,0x4011,0,0,1,RACE_DINOSAUR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,50000193)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end