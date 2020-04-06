-- Fairy Spirit - Gemini

function c50000095.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000095,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c50000095.condition)
	e1:SetOperation(c50000095.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000095,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(c50000095.rlcon)
	e2:SetTarget(c50000095.rltg)
	e2:SetOperation(c50000095.rlop)
	c:RegisterEffect(e2)
end

function c50000095.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()~=2
end
function c50000095.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

function c50000095.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousLevelOnField()==2
end
function c50000095.filter(c)
	return (c:IsType(TYPE_RITUAL) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()==1850)) and c:IsType(TYPE_MONSTER) and not c:IsCode(50000095) and c:IsAbleToHand()
end
function c50000095.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c50000095.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000095.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c50000095.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c50000095.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end