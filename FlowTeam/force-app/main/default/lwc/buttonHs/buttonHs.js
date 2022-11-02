import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ButtonHs extends NavigationMixin(LightningElement)  {

    navigateToListView() {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'list'
            },
            state: {
                filterName: '00BDn000003hGayMAE' 
                //filterName: 'Recent' 
            }
        });
    }
}