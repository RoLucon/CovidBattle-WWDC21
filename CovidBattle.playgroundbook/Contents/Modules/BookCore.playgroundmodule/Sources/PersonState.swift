
public enum PersonState: CaseIterable {
    case masked, infected, vaccined, unMasked, crying
    
    public var imageName: String {
        switch self {
        case .masked:
            return "MaskFace.png"
        case .infected:
            return "NauseatedFace.png"
        case .vaccined:
            return "MaskFace.png"
        case .unMasked:
            return "HappyFace.png"
        case .crying:
            return "CryFace.png"
        }
        
    }
    
}
