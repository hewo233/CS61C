#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *slow = head, *fast = head;
    if(head == NULL || head->next == NULL)
    {
        return 0;
    }

    do 
    {
        if(fast->next == NULL) return 0;
        if(fast->next->next == NULL) return 0;
        slow = slow->next;
        fast = fast->next->next;
        if(slow == fast) return 1;
    }while(slow != fast);

    return 0;
}