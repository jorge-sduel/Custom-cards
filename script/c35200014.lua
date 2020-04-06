--- Elemental HERO Reboot Sparkman

function c35200014.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(20721928)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35200011,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,352000141)
	e2:SetCost(c35200014.descost)
	e2:SetTarget(c35200014.thtg)
	e2:SetOperation(c35200014.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35200011,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,352000142)
	e3:SetCost(c35200014.negcost)
	e3:SetTarget(c35200014.sptg)
	e3:SetOperation(c35200014.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(35200014,ACTIVITY_SPSUMMON,c35200014.counterfilter)
end

function c35200014.counterfilter(c)
	return c:IsSetCard(0x3008)
end
function c35200014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(35200014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c35200014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c35200014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3008)
end
function c35200014.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c35200014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35200014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c35200014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c35200014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c35200014.cfilter(c)
	return c:IsDiscardable()
end
function c35200014.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35200014.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c35200014.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c35200014.filter1(c,e,tp)
	return c:IsSetCard(0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35200014.filter2(c,g)
	return g:IsExists(c35200014.filter3,1,c,c:GetAttribute())
end
function c35200014.filter3(c,attribute)
	return not c:IsAttribute(attribute)
end
function c35200014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		local g=Duel.GetMatchingGroup(c35200014.filter1,tp,LOCATION_DECK,0,nil,e,tp)
		return g:IsExists(c35200014.filter2,1,nil,g)
	end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c35200014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c35200014.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c35200014.filter2,nil,g)
	if dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsAttribute,nil,tc1:GetAttribute())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end
