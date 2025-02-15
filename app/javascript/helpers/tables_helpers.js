export function tableContentFor(application, tableGuid) {
    const contentControllerIdentifier = `[data-controller~=tables--content][data-table-guid="${tableGuid}"]`
    const contentControllerElement = document.querySelector(contentControllerIdentifier)
    return application.getControllerForElementAndIdentifier(
        contentControllerElement,
        'tables--content'
    )
}
