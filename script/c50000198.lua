--Yoyo Dino Brave Red
function c50000198.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c50000198.sptg)
	e1:SetOperation(c50000198.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000198,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCost(c50000198.cost)
	e2:SetTarget(c50000198.tg)
	e2:SetOperation(c50000198.op)
	c:RegisterEffect(e2)
end

function c50000198.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c50000198.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x70a) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c50000198.ndcfilter(c)
	return c:IsFaceup() and c:IsCode(50000191)
end
function c50000198.exfilter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c50000198.exfilter1(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c50000198.fcheck(tp,sg,fc)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end
function c50000198.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		if Duel.IsExistingMatchingCard(c50000198.ndcfilter,tp,LOCATION_ONFIELD,0,1,nil) then
            local sg=Duel.GetMatchingGroup(c50000198.exfilter0,tp,LOCATION_EXTRA,0,nil)
            if sg:GetCount()>0 then
                mg1:Merge(sg)
                Auxiliary.FCheckAdditional=c50000198.fcheck
            end
        end
		local res=Duel.IsExistingMatchingCard(c50000198.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c50000198.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50000198.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x70a)
end
function c50000198.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c50000198.filter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c50000198.ndcfilter,tp,LOCATION_MZONE,0,1,nil) then
        local sg=Duel.GetMatchingGroup(c50000198.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
        if sg:GetCount()>0 then
            mg1:Merge(sg)
            exmat=true
        end
    end
    if exmat then Auxiliary.FCheckAdditional=c50000198.fcheck end
	local sg1=Duel.GetMatchingGroup(c50000198.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c50000198.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then Auxiliary.FCheckAdditional=c50000198.fcheck end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local g=Duel.GetMatchingGroup(c50000198.desfilter,tp,LOCATION_ONFIELD,0,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

function c50000198.cfilter(c)
	return c:IsCode(50000191)
end
function c50000198.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c50000198.cfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,c50000198.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c50000198.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50000198.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end