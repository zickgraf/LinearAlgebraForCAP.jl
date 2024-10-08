# SPDX-License-Identifier: GPL-2.0-or-later
# LinearAlgebraForCAP: Category of Matrices over a Field for CAP
#
# Implementations
#

####################################
##
## Constructors
##
####################################

##
@InstallMethod( MatrixCategory_as_CategoryOfRows,
               [ IsFieldForHomalg ],
               
  function( homalg_ring )
    local rows, object_constructor, modeling_tower_object_constructor, object_datum, modeling_tower_object_datum, morphism_constructor, modeling_tower_morphism_constructor, morphism_datum, modeling_tower_morphism_datum, wrapper;
    
    rows = CategoryOfRows( homalg_ring; FinalizeCategory = true, no_precompiled_code = false ); # we do @not want to recompile CategoryOfRows
    
    object_constructor = function ( cat, dimension )
        
        if (!(IsInt( dimension )) || dimension < 0)
            
            Error( "the object datum must be a non-negative integer" );
            
        end;
        
        return AsCapCategoryObject( cat, dimension );
        
    end;
    
    modeling_tower_object_constructor = function ( cat, dimension )
        
        if (!(IsInt( dimension )) || dimension < 0)
            
            Error( "the object datum must be a non-negative integer" );
            
        end;
        
        return CreateCapCategoryObjectWithAttributes( ModelingCategory( cat ), RankOfObject, dimension );
        
    end;
    
    object_datum = function ( cat, object )
        
        return AsInteger( object );
        
    end;
    
    modeling_tower_object_datum = function ( cat, object )
        
        return RankOfObject( object );
        
    end;
    
    morphism_constructor = function ( cat, source, homalg_matrix, range )
        
        if (@not IsHomalgMatrix( homalg_matrix ))
            
            Error( "the morphism datum must be a homalg matrix" );
            
        end;
        
        if (@not IsIdenticalObj( HomalgRing( homalg_matrix ), UnderlyingRing( cat ) ))
            
            Error( "the matrix is defined over a different ring than the category" );
            
        end;
        
        if (NrRows( homalg_matrix ) != ObjectDatum( cat, source ))
            
            Error( "the number of rows has to be equal to the dimension of the source" );
            
        end;
        
        if (NrColumns( homalg_matrix ) != ObjectDatum( cat, range ))
            
            Error( "the number of columns has to be equal to the dimension of the range" );
            
        end;
        
        return AsCapCategoryMorphism( cat, source, homalg_matrix, range );
        
    end;
    
    modeling_tower_morphism_constructor = function ( cat, source, homalg_matrix, range )
        
        if (@not IsHomalgMatrix( homalg_matrix ))
            
            Error( "the morphism datum must be a homalg matrix" );
            
        end;
        
        if (@not IsIdenticalObj( HomalgRing( homalg_matrix ), UnderlyingRing( cat ) ))
            
            Error( "the matrix is defined over a different ring than the category" );
            
        end;
        
        if (NrRows( homalg_matrix ) != ObjectDatum( ModelingCategory( cat ), source ))
            
            Error( "the number of rows has to be equal to the dimension of the source" );
            
        end;
        
        if (NrColumns( homalg_matrix ) != ObjectDatum( ModelingCategory( cat ), range ))
            
            Error( "the number of columns has to be equal to the dimension of the range" );
            
        end;
        
        return CreateCapCategoryMorphismWithAttributes( ModelingCategory( cat ), source, range,
                                                        UnderlyingMatrix, homalg_matrix
        );
        
    end;
    
    morphism_datum = function ( cat, morphism )
        
        return AsHomalgMatrix( morphism );
        
    end;
    
    modeling_tower_morphism_datum = function ( cat, morphism )
        
        return UnderlyingMatrix( morphism );
        
    end;
    
    wrapper = ReinterpretationOfCategory( rows, @rec(
        name = @Concatenation( "Category of matrices over ", RingName( homalg_ring ) ),
        category_filter = IsMatrixCategory,
        category_object_filter = IsVectorSpaceObject && HasAsInteger && HasIsProjective && IsProjective,
        category_morphism_filter = IsVectorSpaceMorphism && HasAsHomalgMatrix,
        object_datum_type = IsInt,
        morphism_datum_type = @rec( filter = IsHomalgMatrix, ring = homalg_ring ),
        object_constructor = object_constructor,
        object_datum = object_datum,
        morphism_constructor = morphism_constructor,
        morphism_datum = morphism_datum,
        modeling_tower_object_constructor = modeling_tower_object_constructor,
        modeling_tower_object_datum = modeling_tower_object_datum,
        modeling_tower_morphism_constructor = modeling_tower_morphism_constructor,
        modeling_tower_morphism_datum = modeling_tower_morphism_datum,
        only_primitive_operations = true,
    ); FinalizeCategory = false );
    
    SetUnderlyingRing( wrapper, homalg_ring );
    
    wrapper.compiler_hints.category_attribute_names = [
        "UnderlyingRing",
    ];
    
    wrapper.compiler_hints.source_and_range_attributes_from_morphism_attribute = @rec(
        object_attribute_name = "AsInteger",
        morphism_attribute_name = "AsHomalgMatrix",
        source_attribute_getter_name = "NumberRows",
        range_attribute_getter_name = "NumberColumns",
    );
    
    Finalize( wrapper );
    
    return wrapper;
    
end );
