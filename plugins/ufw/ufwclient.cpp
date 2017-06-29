#include "ufwclient.h"

UfwClient::UfwClient(QObject *parent) : QObject(parent)
{

}

bool UfwClient::isActive()
{
    return false;
}
