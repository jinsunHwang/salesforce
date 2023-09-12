var action = component.get('c.saveCollect');
        action.setParams({
            'listCarton'   : listCartonParam
            ,'listCollect' : listCollect
            ,'userId':userId
            ,'userCenterId' : getUserCenterId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
